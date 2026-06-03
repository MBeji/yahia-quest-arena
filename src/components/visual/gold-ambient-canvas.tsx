import { useMemo, useRef } from "react";
import { Canvas, useFrame } from "@react-three/fiber";
import * as THREE from "three";

/**
 * Lightweight 3D golden particle ambient for the dashboard hub. Client-only,
 * lazy-loaded (shares the `vendor-three` chunk). Deliberately minimal — points
 * only, no shader, dpr 1 — to stay 60fps behind a data-dense page. Gated by the
 * caller (reduced-motion / mobile fall back to the CSS gold ambient).
 */

function Particles() {
  const ref = useRef<THREE.Points>(null);
  const COUNT = 600;
  const positions = useMemo(() => {
    const arr = new Float32Array(COUNT * 3);
    for (let i = 0; i < COUNT; i++) {
      arr[i * 3] = (Math.random() - 0.5) * 16;
      arr[i * 3 + 1] = (Math.random() - 0.5) * 10;
      arr[i * 3 + 2] = (Math.random() - 0.5) * 8;
    }
    return arr;
  }, []);
  const args = useMemo(() => [positions, 3] as [Float32Array, number], [positions]);

  useFrame((state, delta) => {
    const pts = ref.current;
    if (!pts) return;
    pts.rotation.y += delta * 0.03;
    pts.position.x = Math.sin(state.clock.elapsedTime * 0.1) * 0.4;
  });

  return (
    <points ref={ref}>
      <bufferGeometry>
        <bufferAttribute attach="attributes-position" args={args} />
      </bufferGeometry>
      <pointsMaterial
        color="#d9b25a"
        size={0.045}
        sizeAttenuation
        transparent
        opacity={0.5}
        depthWrite={false}
        blending={THREE.AdditiveBlending}
      />
    </points>
  );
}

export default function GoldAmbientCanvas() {
  return (
    <Canvas
      camera={{ position: [0, 0, 9], fov: 55 }}
      dpr={1}
      gl={{ antialias: false, alpha: true, powerPreference: "high-performance" }}
      onCreated={({ gl }) => gl.setClearColor(0x000000, 0)}
      style={{ pointerEvents: "none" }}
    >
      <Particles />
    </Canvas>
  );
}
