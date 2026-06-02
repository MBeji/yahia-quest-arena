import { useContext } from "react";
import { I18nContext } from "./context";

export function useI18n() {
  return useContext(I18nContext);
}

export function useT() {
  return useContext(I18nContext).t;
}
