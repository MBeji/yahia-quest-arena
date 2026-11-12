import { createStart, createMiddleware, createCsrfMiddleware } from "@tanstack/react-start";
import { attachSupabaseAuth } from "@/shared/integrations/supabase/auth-attacher";
import { captureError } from "@/shared/lib/error-capture";
import { renderErrorPage } from "@/shared/lib/error-page";

const csrfMiddleware = createCsrfMiddleware({
  filter: (ctx) => ctx.handlerType === "serverFn",
});

const errorMiddleware = createMiddleware().server(async ({ next }) => {
  try {
    return await next();
  } catch (error) {
    if (error != null && typeof error === "object" && "statusCode" in error) {
      // Le framework va en faire une réponse — et, pour un statut d'erreur HTTP,
      // sans même la journaliser. On garde l'original pour server.ts.
      captureError(error);
      throw error;
    }
    console.error(error);
    return new Response(renderErrorPage(), {
      status: 500,
      headers: { "content-type": "text/html; charset=utf-8" },
    });
  }
});

export const startInstance = createStart(() => ({
  requestMiddleware: [csrfMiddleware, errorMiddleware],
  functionMiddleware: [attachSupabaseAuth],
}));
