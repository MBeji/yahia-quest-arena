export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5";
  };
  graphql_public: {
    Tables: {
      [_ in never]: never;
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      graphql: {
        Args: {
          extensions?: Json;
          operationName?: string;
          query?: string;
          variables?: Json;
        };
        Returns: Json;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
  public: {
    Tables: {
      attempts: {
        Row: {
          completed_at: string;
          correct_count: number;
          duration_seconds: number;
          exercise_id: string;
          id: string;
          score_pct: number;
          subject_id: string;
          total_count: number;
          user_id: string;
          xp_earned: number;
        };
        Insert: {
          completed_at?: string;
          correct_count: number;
          duration_seconds: number;
          exercise_id: string;
          id?: string;
          score_pct: number;
          subject_id: string;
          total_count: number;
          user_id: string;
          xp_earned: number;
        };
        Update: {
          completed_at?: string;
          correct_count?: number;
          duration_seconds?: number;
          exercise_id?: string;
          id?: string;
          score_pct?: number;
          subject_id?: string;
          total_count?: number;
          user_id?: string;
          xp_earned?: number;
        };
        Relationships: [
          {
            foreignKeyName: "attempts_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "attempts_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
      badges: {
        Row: {
          code: string;
          created_at: string;
          description: string | null;
          icon_name: string | null;
          id: string;
          name: string;
          rarity: string;
          rule_key: string | null;
        };
        Insert: {
          code: string;
          created_at?: string;
          description?: string | null;
          icon_name?: string | null;
          id?: string;
          name: string;
          rarity?: string;
          rule_key?: string | null;
        };
        Update: {
          code?: string;
          created_at?: string;
          description?: string | null;
          icon_name?: string | null;
          id?: string;
          name?: string;
          rarity?: string;
          rule_key?: string | null;
        };
        Relationships: [];
      };
      chapters: {
        Row: {
          description: string | null;
          display_order: number;
          id: string;
          subject_id: string;
          title: string;
        };
        Insert: {
          description?: string | null;
          display_order?: number;
          id?: string;
          subject_id: string;
          title: string;
        };
        Update: {
          description?: string | null;
          display_order?: number;
          id?: string;
          subject_id?: string;
          title?: string;
        };
        Relationships: [
          {
            foreignKeyName: "chapters_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
      exercise_assignments: {
        Row: {
          assigned_by_user_id: string;
          completed_at: string | null;
          created_at: string;
          due_at: string | null;
          exercise_id: string;
          id: string;
          status: string;
          student_user_id: string;
        };
        Insert: {
          assigned_by_user_id: string;
          completed_at?: string | null;
          created_at?: string;
          due_at?: string | null;
          exercise_id: string;
          id?: string;
          status?: string;
          student_user_id: string;
        };
        Update: {
          assigned_by_user_id?: string;
          completed_at?: string | null;
          created_at?: string;
          due_at?: string | null;
          exercise_id?: string;
          id?: string;
          status?: string;
          student_user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "exercise_assignments_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
        ];
      };
      exercise_sessions: {
        Row: {
          completed_at: string | null;
          created_at: string;
          exercise_id: string;
          id: string;
          started_at: string;
          user_id: string;
        };
        Insert: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id: string;
          id?: string;
          started_at?: string;
          user_id: string;
        };
        Update: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id?: string;
          id?: string;
          started_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "exercise_sessions_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
        ];
      };
      exercises: {
        Row: {
          chapter_id: string;
          created_by: string | null;
          difficulty: number;
          display_order: number;
          id: string;
          mode: string;
          reward_coins: number;
          source: string;
          subject_id: string;
          target_student_id: string | null;
          title: string;
          xp_reward: number;
        };
        Insert: {
          chapter_id: string;
          created_by?: string | null;
          difficulty?: number;
          display_order?: number;
          id?: string;
          mode?: string;
          reward_coins?: number;
          source?: string;
          subject_id: string;
          target_student_id?: string | null;
          title: string;
          xp_reward?: number;
        };
        Update: {
          chapter_id?: string;
          created_by?: string | null;
          difficulty?: number;
          display_order?: number;
          id?: string;
          mode?: string;
          reward_coins?: number;
          source?: string;
          subject_id?: string;
          target_student_id?: string | null;
          title?: string;
          xp_reward?: number;
        };
        Relationships: [
          {
            foreignKeyName: "exercises_chapter_id_fkey";
            columns: ["chapter_id"];
            isOneToOne: false;
            referencedRelation: "chapters";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "exercises_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
      inventory_items: {
        Row: {
          acquired_at: string;
          id: string;
          is_equipped: boolean;
          quantity: number;
          shop_item_id: string;
          student_user_id: string;
        };
        Insert: {
          acquired_at?: string;
          id?: string;
          is_equipped?: boolean;
          quantity?: number;
          shop_item_id: string;
          student_user_id: string;
        };
        Update: {
          acquired_at?: string;
          id?: string;
          is_equipped?: boolean;
          quantity?: number;
          shop_item_id?: string;
          student_user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "inventory_items_shop_item_id_fkey";
            columns: ["shop_item_id"];
            isOneToOne: false;
            referencedRelation: "shop_items";
            referencedColumns: ["id"];
          },
        ];
      };
      parent_student_links: {
        Row: {
          created_at: string;
          id: string;
          is_active: boolean;
          parent_user_id: string;
          relation_label: string;
          student_user_id: string;
        };
        Insert: {
          created_at?: string;
          id?: string;
          is_active?: boolean;
          parent_user_id: string;
          relation_label?: string;
          student_user_id: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          is_active?: boolean;
          parent_user_id?: string;
          relation_label?: string;
          student_user_id?: string;
        };
        Relationships: [];
      };
      profiles: {
        Row: {
          avatar_slug: string | null;
          avatar_tier: number;
          created_at: string;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          xp: number;
          yahia_coins: number;
        };
        Insert: {
          avatar_slug?: string | null;
          avatar_tier?: number;
          created_at?: string;
          current_streak?: number;
          display_name?: string;
          hero_class?: string;
          id: string;
          last_active_date?: string | null;
          level?: number;
          longest_streak?: number;
          role?: string;
          xp?: number;
          yahia_coins?: number;
        };
        Update: {
          avatar_slug?: string | null;
          avatar_tier?: number;
          created_at?: string;
          current_streak?: number;
          display_name?: string;
          hero_class?: string;
          id?: string;
          last_active_date?: string | null;
          level?: number;
          longest_streak?: number;
          role?: string;
          xp?: number;
          yahia_coins?: number;
        };
        Relationships: [];
      };
      questions: {
        Row: {
          correct_option: string;
          display_order: number;
          exercise_id: string;
          explanation: string | null;
          id: string;
          options: Json;
          prompt: string;
        };
        Insert: {
          correct_option: string;
          display_order?: number;
          exercise_id: string;
          explanation?: string | null;
          id?: string;
          options: Json;
          prompt: string;
        };
        Update: {
          correct_option?: string;
          display_order?: number;
          exercise_id?: string;
          explanation?: string | null;
          id?: string;
          options?: Json;
          prompt?: string;
        };
        Relationships: [
          {
            foreignKeyName: "questions_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
        ];
      };
      shop_items: {
        Row: {
          code: string;
          created_at: string;
          description: string | null;
          effect_payload: Json;
          id: string;
          is_active: boolean;
          item_type: string;
          name: string;
          price_coins: number;
        };
        Insert: {
          code: string;
          created_at?: string;
          description?: string | null;
          effect_payload?: Json;
          id?: string;
          is_active?: boolean;
          item_type: string;
          name: string;
          price_coins: number;
        };
        Update: {
          code?: string;
          created_at?: string;
          description?: string | null;
          effect_payload?: Json;
          id?: string;
          is_active?: boolean;
          item_type?: string;
          name?: string;
          price_coins?: number;
        };
        Relationships: [];
      };
      student_badges: {
        Row: {
          awarded_at: string;
          awarded_by: string | null;
          awarded_reason: string | null;
          badge_id: string;
          id: string;
          student_user_id: string;
        };
        Insert: {
          awarded_at?: string;
          awarded_by?: string | null;
          awarded_reason?: string | null;
          badge_id: string;
          id?: string;
          student_user_id: string;
        };
        Update: {
          awarded_at?: string;
          awarded_by?: string | null;
          awarded_reason?: string | null;
          badge_id?: string;
          id?: string;
          student_user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "student_badges_badge_id_fkey";
            columns: ["badge_id"];
            isOneToOne: false;
            referencedRelation: "badges";
            referencedColumns: ["id"];
          },
        ];
      };
      subjects: {
        Row: {
          attribute: string;
          color_token: string;
          description: string | null;
          display_order: number;
          icon: string;
          id: string;
          name_fr: string;
        };
        Insert: {
          attribute: string;
          color_token: string;
          description?: string | null;
          display_order?: number;
          icon: string;
          id: string;
          name_fr: string;
        };
        Update: {
          attribute?: string;
          color_token?: string;
          description?: string | null;
          display_order?: number;
          icon?: string;
          id?: string;
          name_fr?: string;
        };
        Relationships: [];
      };
      theory_scrolls: {
        Row: {
          body_md: string;
          chapter_id: string;
          created_at: string;
          created_by: string | null;
          display_order: number;
          estimated_minutes: number;
          id: string;
          source: string;
          subject_id: string;
          summary: string | null;
          target_student_id: string | null;
          title: string;
        };
        Insert: {
          body_md: string;
          chapter_id: string;
          created_at?: string;
          created_by?: string | null;
          display_order?: number;
          estimated_minutes?: number;
          id?: string;
          source?: string;
          subject_id: string;
          summary?: string | null;
          target_student_id?: string | null;
          title: string;
        };
        Update: {
          body_md?: string;
          chapter_id?: string;
          created_at?: string;
          created_by?: string | null;
          display_order?: number;
          estimated_minutes?: number;
          id?: string;
          source?: string;
          subject_id?: string;
          summary?: string | null;
          target_student_id?: string | null;
          title?: string;
        };
        Relationships: [
          {
            foreignKeyName: "theory_scrolls_chapter_id_fkey";
            columns: ["chapter_id"];
            isOneToOne: false;
            referencedRelation: "chapters";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "theory_scrolls_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      award_xp: {
        Args: { p_user: string; p_xp: number };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          created_at: string;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          xp: number;
          yahia_coins: number;
        };
        SetofOptions: {
          from: "*";
          to: "profiles";
          isOneToOne: true;
          isSetofReturn: false;
        };
      };
      is_parent_of_student: {
        Args: { p_parent: string; p_student: string };
        Returns: boolean;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">;

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R;
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] & DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R;
      }
      ? R
      : never
    : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I;
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I;
      }
      ? I
      : never
    : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U;
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U;
      }
      ? U
      : never
    : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never;

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const;
