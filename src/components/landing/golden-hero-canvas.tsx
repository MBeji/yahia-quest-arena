import { useMemo, useRef } from "react";
import { Canvas, useFrame, type ThreeElements } from "@react-three/fiber";
import * as THREE from "three";

/**
 * Golden 3D hero scene for the landing page. Client-only and lazy-loaded
 * (default export) so three.js lands in its own `vendor-three` chunk and never
 * ships to users who don't reach the landing (or who prefer reduced motion).
 *
 * A metallic-gold faceted core (custom GLSL fresnel shader, subtle noise
 * displacement) floats inside a drifting gold particle field, both reacting to
 * the pointer and to scroll. No env maps / HDR (offline-friendly) — the gold is
 * faked with a fresnel rim + a moving specular band.
 */

const vertexShader = /* glsl */ `
  uniform float uTime;
  uniform float uScroll;
  uniform vec2 uPointer;
  varying vec3 vNormal;
  varying vec3 vViewDir;
  varying float vNoise;

  // Cheap value noise (no texture / no import needed).
  vec3 hash3(vec3 p){
    p = vec3(dot(p, vec3(127.1,311.7,74.7)),
             dot(p, vec3(269.5,183.3,246.1)),
             dot(p, vec3(113.5,271.9,124.6)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
  }
  float noise(vec3 p){
    vec3 i = floor(p); vec3 f = fract(p);
    vec3 u = f*f*(3.0-2.0*f);
    return mix(mix(mix(dot(hash3(i+vec3(0,0,0)), f-vec3(0,0,0)),
                       dot(hash3(i+vec3(1,0,0)), f-vec3(1,0,0)), u.x),
                   mix(dot(hash3(i+vec3(0,1,0)), f-vec3(0,1,0)),
                       dot(hash3(i+vec3(1,1,0)), f-vec3(1,1,0)), u.x), u.y),
               mix(mix(dot(hash3(i+vec3(0,0,1)), f-vec3(0,0,1)),
                       dot(hash3(i+vec3(1,0,1)), f-vec3(1,0,1)), u.x),
                   mix(dot(hash3(i+vec3(0,1,1)), f-vec3(0,1,1)),
                       dot(hash3(i+vec3(1,1,1)), f-vec3(1,1,1)), u.x), u.y), u.z);
  }

  void main(){
    float t = uTime * 0.35;
    float n = noise(position * 1.8 + vec3(t, t * 0.7, -t));
    vNoise = n;
    float amp = 0.18 + uScroll * 0.12 + abs(uPointer.x) * 0.05;
    vec3 displaced = position + normal * n * amp;

    vec4 mvPosition = modelViewMatrix * vec4(displaced, 1.0);
    vNormal = normalize(normalMatrix * normal);
    vViewDir = normalize(-mvPosition.xyz);
    gl_Position = projectionMatrix * mvPosition;
  }
`;

const fragmentShader = /* glsl */ `
  precision highp float;
  uniform float uTime;
  varying vec3 vNormal;
  varying vec3 vViewDir;
  varying float vNoise;

  void main(){
    vec3 deepGold   = vec3(0.45, 0.30, 0.06);
    vec3 gold       = vec3(0.86, 0.62, 0.18);
    vec3 champagne  = vec3(1.0, 0.93, 0.72);

    float fres = pow(1.0 - clamp(dot(normalize(vNormal), normalize(vViewDir)), 0.0, 1.0), 2.2);

    // Base gold gradient driven by surface noise.
    vec3 col = mix(deepGold, gold, smoothstep(-0.5, 0.6, vNoise));
    // Fresnel rim → champagne highlight.
    col = mix(col, champagne, fres * 0.9);
    // Moving specular band for a liquid-metal sheen.
    float band = sin(vNoise * 6.0 + uTime * 1.2);
    col += champagne * smoothstep(0.85, 1.0, band) * 0.6;

    gl_FragColor = vec4(col, 1.0);
  }
`;

function GoldCore({ scroll }: { scroll: React.MutableRefObject<number> }) {
  const meshRef = useRef<THREE.Mesh>(null);
  const geometry = useMemo(() => new THREE.IcosahedronGeometry(1.45, 24), []);
  const material = useMemo(
    () =>
      new THREE.ShaderMaterial({
        uniforms: {
          uTime: { value: 0 },
          uScroll: { value: 0 },
          uPointer: { value: new THREE.Vector2(0, 0) },
        },
        vertexShader,
        fragmentShader,
      }),
    [],
  );

  useFrame((state, delta) => {
    const u = material.uniforms;
    u.uTime.value = state.clock.elapsedTime;
    u.uScroll.value = scroll.current;
    u.uPointer.value.set(state.pointer.x, state.pointer.y);
    const mesh = meshRef.current;
    if (!mesh) return;
    mesh.rotation.y += delta * 0.18;
    // Gentle parallax toward the pointer.
    mesh.rotation.x = THREE.MathUtils.lerp(mesh.rotation.x, state.pointer.y * 0.35, 0.05);
    mesh.position.y = THREE.MathUtils.lerp(mesh.position.y, state.pointer.y * 0.18, 0.04);
    const s = 1 + scroll.current * 0.15;
    mesh.scale.setScalar(THREE.MathUtils.lerp(mesh.scale.x, s, 0.06));
  });

  return <mesh ref={meshRef} geometry={geometry} material={material} />;
}

function GoldParticles() {
  const ref = useRef<THREE.Points>(null);
  const COUNT = 900;
  const positions = useMemo(() => {
    const arr = new Float32Array(COUNT * 3);
    for (let i = 0; i < COUNT; i++) {
      const r = 2.6 + Math.random() * 3.4;
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos(2 * Math.random() - 1);
      arr[i * 3] = r * Math.sin(phi) * Math.cos(theta);
      arr[i * 3 + 1] = r * Math.sin(phi) * Math.sin(theta);
      arr[i * 3 + 2] = r * Math.cos(phi);
    }
    return arr;
  }, []);

  useFrame((state, delta) => {
    const pts = ref.current;
    if (!pts) return;
    pts.rotation.y += delta * 0.04;
    pts.rotation.x = THREE.MathUtils.lerp(pts.rotation.x, state.pointer.y * 0.1, 0.03);
  });

  const geomArgs = useMemo(() => [positions, 3] as const, [positions]);

  return (
    <points ref={ref}>
      <bufferGeometry>
        <bufferAttribute attach="attributes-position" args={geomArgs} />
      </bufferGeometry>
      <pointsMaterial
        color="#e9c66a"
        size={0.028}
        sizeAttenuation
        transparent
        opacity={0.85}
        depthWrite={false}
        blending={THREE.AdditiveBlending}
      />
    </points>
  );
}

// Typed lights so the JSX compiles under @react-three/fiber v9 TS settings.
function Lights() {
  const ambient: ThreeElements["ambientLight"] = { intensity: 0.4 };
  const point: ThreeElements["pointLight"] = {
    position: [4, 3, 5],
    intensity: 30,
    color: "#ffe9b0",
  };
  return (
    <>
      <ambientLight {...ambient} />
      <pointLight {...point} />
    </>
  );
}

export default function GoldenHeroCanvas() {
  const scroll = useRef(0);

  return (
    <Canvas
      camera={{ position: [0, 0, 5], fov: 45 }}
      dpr={[1, 1.6]}
      gl={{ antialias: true, alpha: true, powerPreference: "high-performance" }}
      onCreated={({ gl }) => gl.setClearColor(0x000000, 0)}
      style={{ pointerEvents: "none" }}
    >
      <Lights />
      <ScrollTracker scroll={scroll} />
      <GoldCore scroll={scroll} />
      <GoldParticles />
    </Canvas>
  );
}

/** Tracks normalized page scroll (0→1 over the first viewport) into a ref. */
function ScrollTracker({ scroll }: { scroll: React.MutableRefObject<number> }) {
  useFrame(() => {
    if (typeof window === "undefined") return;
    const max = window.innerHeight || 1;
    scroll.current = Math.min(1, window.scrollY / max);
  });
  return null;
}
