import { useEffect, useState } from "react";
import type { Session, User } from "@supabase/supabase-js";
import { supabase } from "@/shared/integrations/supabase/client";
import { logger } from "@/shared/lib/logger";

export function useAuth() {
  const [session, setSession] = useState<Session | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_e, s) => {
      setSession(s);
      setUser(s?.user ?? null);
    });
    // `finally` et non `then` : `loading` doit retomber sur les DEUX chemins.
    //
    // Sans le `catch`, une lecture de session qui rejette laissait `loading` à
    // `true` POUR TOUJOURS — et c'est le mur de connexion qui en dépend :
    // `routes/_authenticated.tsx` rend son écran d'attente tant que `loading`, donc
    // son effet de redirection (gaté sur `!loading`) ne partait jamais. Une route
    // de compte restait alors affichée à un visiteur sans session, indéfiniment.
    //
    // La posture juste pour une garde est de **se fermer**, pas de rester ouverte :
    // une session qu'on n'arrive pas à LIRE n'est pas une session.
    supabase.auth
      .getSession()
      .then(({ data }) => {
        setSession(data.session);
        setUser(data.session?.user ?? null);
      })
      .catch((error: unknown) => {
        logger.error("auth.getSession", { error: error instanceof Error ? error.message : error });
        setSession(null);
        setUser(null);
      })
      .finally(() => setLoading(false));
    return () => subscription.unsubscribe();
  }, []);

  return { session, user, loading };
}
