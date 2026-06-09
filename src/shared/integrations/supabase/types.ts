export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5";
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
      beta_access_requests: {
        Row: {
          created_at: string;
          email: string;
          id: string;
          motivation: string | null;
          name: string;
          reviewed_at: string | null;
          reviewed_by: string | null;
          status: string;
          user_id: string;
        };
        Insert: {
          created_at?: string;
          email: string;
          id?: string;
          motivation?: string | null;
          name: string;
          reviewed_at?: string | null;
          reviewed_by?: string | null;
          status?: string;
          user_id: string;
        };
        Update: {
          created_at?: string;
          email?: string;
          id?: string;
          motivation?: string | null;
          name?: string;
          reviewed_at?: string | null;
          reviewed_by?: string | null;
          status?: string;
          user_id?: string;
        };
        Relationships: [];
      };
      chapters: {
        Row: {
          description: string | null;
          display_order: number;
          id: string;
          lesson_content: string | null;
          subject_id: string;
          summary: string | null;
          title: string;
        };
        Insert: {
          description?: string | null;
          display_order?: number;
          id?: string;
          lesson_content?: string | null;
          subject_id: string;
          summary?: string | null;
          title: string;
        };
        Update: {
          description?: string | null;
          display_order?: number;
          id?: string;
          lesson_content?: string | null;
          subject_id?: string;
          summary?: string | null;
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
      content_reports: {
        Row: {
          created_at: string;
          exercise_id: string | null;
          id: string;
          message: string;
          question_id: string | null;
          resolved_at: string | null;
          resolved_by: string | null;
          status: string;
          user_id: string;
        };
        Insert: {
          created_at?: string;
          exercise_id?: string | null;
          id?: string;
          message: string;
          question_id?: string | null;
          resolved_at?: string | null;
          resolved_by?: string | null;
          status?: string;
          user_id: string;
        };
        Update: {
          created_at?: string;
          exercise_id?: string | null;
          id?: string;
          message?: string;
          question_id?: string | null;
          resolved_at?: string | null;
          resolved_by?: string | null;
          status?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "content_reports_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "content_reports_question_id_fkey";
            columns: ["question_id"];
            isOneToOne: false;
            referencedRelation: "questions";
            referencedColumns: ["id"];
          },
        ];
      };
      daily_objectives: {
        Row: {
          coin_reward: number;
          completed_at: string | null;
          created_at: string;
          current_value: number;
          id: string;
          objective_date: string;
          objective_type: string;
          status: string;
          target_value: number;
          user_id: string;
          xp_reward: number;
        };
        Insert: {
          coin_reward?: number;
          completed_at?: string | null;
          created_at?: string;
          current_value?: number;
          id?: string;
          objective_date: string;
          objective_type: string;
          status?: string;
          target_value: number;
          user_id: string;
          xp_reward?: number;
        };
        Update: {
          coin_reward?: number;
          completed_at?: string | null;
          created_at?: string;
          current_value?: number;
          id?: string;
          objective_date?: string;
          objective_type?: string;
          status?: string;
          target_value?: number;
          user_id?: string;
          xp_reward?: number;
        };
        Relationships: [];
      };
      difficulty_adaptation: {
        Row: {
          avg_score: number;
          created_at: string;
          current_difficulty_level: number;
          id: string;
          last_adjusted_at: string | null;
          recent_avg_score: number;
          subject_id: string;
          total_attempts: number;
          updated_at: string;
          user_id: string;
        };
        Insert: {
          avg_score?: number;
          created_at?: string;
          current_difficulty_level?: number;
          id?: string;
          last_adjusted_at?: string | null;
          recent_avg_score?: number;
          subject_id: string;
          total_attempts?: number;
          updated_at?: string;
          user_id: string;
        };
        Update: {
          avg_score?: number;
          created_at?: string;
          current_difficulty_level?: number;
          id?: string;
          last_adjusted_at?: string | null;
          recent_avg_score?: number;
          subject_id?: string;
          total_attempts?: number;
          updated_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "difficulty_adaptation_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
      dungeon_run_questions: {
        Row: {
          answered_at: string | null;
          assigned_floor: number;
          created_at: string;
          id: number;
          is_correct: boolean | null;
          question_id: string;
          run_id: string;
          selected_choice: string | null;
        };
        Insert: {
          answered_at?: string | null;
          assigned_floor: number;
          created_at?: string;
          id?: number;
          is_correct?: boolean | null;
          question_id: string;
          run_id: string;
          selected_choice?: string | null;
        };
        Update: {
          answered_at?: string | null;
          assigned_floor?: number;
          created_at?: string;
          id?: number;
          is_correct?: boolean | null;
          question_id?: string;
          run_id?: string;
          selected_choice?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "dungeon_run_questions_question_id_fkey";
            columns: ["question_id"];
            isOneToOne: false;
            referencedRelation: "questions";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "dungeon_run_questions_run_id_fkey";
            columns: ["run_id"];
            isOneToOne: false;
            referencedRelation: "dungeon_runs";
            referencedColumns: ["id"];
          },
        ];
      };
      dungeon_runs: {
        Row: {
          created_at: string;
          current_floor: number;
          duration_seconds: number | null;
          ended_at: string | null;
          floors_cleared: number;
          id: string;
          rewarded_at: string | null;
          started_at: string;
          status: string;
          total_answered: number;
          total_correct: number;
          user_id: string;
        };
        Insert: {
          created_at?: string;
          current_floor?: number;
          duration_seconds?: number | null;
          ended_at?: string | null;
          floors_cleared?: number;
          id?: string;
          rewarded_at?: string | null;
          started_at?: string;
          status?: string;
          total_answered?: number;
          total_correct?: number;
          user_id: string;
        };
        Update: {
          created_at?: string;
          current_floor?: number;
          duration_seconds?: number | null;
          ended_at?: string | null;
          floors_cleared?: number;
          id?: string;
          rewarded_at?: string | null;
          started_at?: string;
          status?: string;
          total_answered?: number;
          total_correct?: number;
          user_id?: string;
        };
        Relationships: [];
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
      grades: {
        Row: {
          cycle: string | null;
          display_order: number;
          id: string;
          is_concours_national: boolean;
          name_fr: string;
          slug: string;
          theme_id: string;
        };
        Insert: {
          cycle?: string | null;
          display_order?: number;
          id?: string;
          is_concours_national?: boolean;
          name_fr: string;
          slug: string;
          theme_id: string;
        };
        Update: {
          cycle?: string | null;
          display_order?: number;
          id?: string;
          is_concours_national?: boolean;
          name_fr?: string;
          slug?: string;
          theme_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "grades_theme_id_fkey";
            columns: ["theme_id"];
            isOneToOne: false;
            referencedRelation: "themes";
            referencedColumns: ["id"];
          },
        ];
      };
      inventory_items: {
        Row: {
          acquired_at: string;
          id: string;
          is_active: boolean;
          is_equipped: boolean;
          quantity: number;
          shop_item_id: string;
          student_user_id: string;
        };
        Insert: {
          acquired_at?: string;
          id?: string;
          is_active?: boolean;
          is_equipped?: boolean;
          quantity?: number;
          shop_item_id: string;
          student_user_id: string;
        };
        Update: {
          acquired_at?: string;
          id?: string;
          is_active?: boolean;
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
      parcours: {
        Row: {
          color: string;
          display_order: number;
          grade_id: string | null;
          icon: string;
          id: string;
          is_premium: boolean;
          kind: string;
          name_ar: string | null;
          name_en: string | null;
          name_fr: string;
          preview_policy: string;
          status: string;
          theme_id: string;
        };
        Insert: {
          color: string;
          display_order?: number;
          grade_id?: string | null;
          icon: string;
          id: string;
          is_premium?: boolean;
          kind: string;
          name_ar?: string | null;
          name_en?: string | null;
          name_fr: string;
          preview_policy?: string;
          status?: string;
          theme_id: string;
        };
        Update: {
          color?: string;
          display_order?: number;
          grade_id?: string | null;
          icon?: string;
          id?: string;
          is_premium?: boolean;
          kind?: string;
          name_ar?: string | null;
          name_en?: string | null;
          name_fr?: string;
          preview_policy?: string;
          status?: string;
          theme_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "parcours_grade_id_fkey";
            columns: ["grade_id"];
            isOneToOne: false;
            referencedRelation: "grades";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "parcours_theme_id_fkey";
            columns: ["theme_id"];
            isOneToOne: false;
            referencedRelation: "themes";
            referencedColumns: ["id"];
          },
        ];
      };
      parcours_entitlements: {
        Row: {
          expires_at: string | null;
          granted_at: string;
          granted_by: string | null;
          id: string;
          parcours_id: string;
          revoked_at: string | null;
          source: string;
          user_id: string;
        };
        Insert: {
          expires_at?: string | null;
          granted_at?: string;
          granted_by?: string | null;
          id?: string;
          parcours_id: string;
          revoked_at?: string | null;
          source: string;
          user_id: string;
        };
        Update: {
          expires_at?: string | null;
          granted_at?: string;
          granted_by?: string | null;
          id?: string;
          parcours_id?: string;
          revoked_at?: string | null;
          source?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "parcours_entitlements_parcours_id_fkey";
            columns: ["parcours_id"];
            isOneToOne: false;
            referencedRelation: "parcours";
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
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
          xp: number;
          yahia_coins: number;
        };
        Insert: {
          avatar_slug?: string | null;
          avatar_tier?: number;
          bosses_defeated?: number;
          created_at?: string;
          current_grade_id?: string | null;
          current_parcours_id?: string | null;
          current_streak?: number;
          display_name?: string;
          hero_class?: string;
          id: string;
          last_active_date?: string | null;
          level?: number;
          longest_streak?: number;
          role?: string;
          total_time_minutes?: number;
          weekly_objectives_completed?: number;
          xp?: number;
          yahia_coins?: number;
        };
        Update: {
          avatar_slug?: string | null;
          avatar_tier?: number;
          bosses_defeated?: number;
          created_at?: string;
          current_grade_id?: string | null;
          current_parcours_id?: string | null;
          current_streak?: number;
          display_name?: string;
          hero_class?: string;
          id?: string;
          last_active_date?: string | null;
          level?: number;
          longest_streak?: number;
          role?: string;
          total_time_minutes?: number;
          weekly_objectives_completed?: number;
          xp?: number;
          yahia_coins?: number;
        };
        Relationships: [
          {
            foreignKeyName: "profiles_current_grade_id_fkey";
            columns: ["current_grade_id"];
            isOneToOne: false;
            referencedRelation: "grades";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "profiles_current_parcours_id_fkey";
            columns: ["current_parcours_id"];
            isOneToOne: false;
            referencedRelation: "parcours";
            referencedColumns: ["id"];
          },
        ];
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
      rate_limit_events: {
        Row: {
          created_at: string;
          id: number;
          scope_key: string;
        };
        Insert: {
          created_at?: string;
          id?: number;
          scope_key: string;
        };
        Update: {
          created_at?: string;
          id?: number;
          scope_key?: string;
        };
        Relationships: [];
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
      spaced_repetition_schedule: {
        Row: {
          completed_at: string | null;
          created_at: string;
          exercise_id: string;
          failed_attempt_id: string | null;
          id: string;
          retry_level: number;
          retry_score_pct: number | null;
          scheduled_for: string;
          status: string;
          subject_id: string;
          updated_at: string;
          user_id: string;
        };
        Insert: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id: string;
          failed_attempt_id?: string | null;
          id?: string;
          retry_level?: number;
          retry_score_pct?: number | null;
          scheduled_for: string;
          status?: string;
          subject_id: string;
          updated_at?: string;
          user_id: string;
        };
        Update: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id?: string;
          failed_attempt_id?: string | null;
          id?: string;
          retry_level?: number;
          retry_score_pct?: number | null;
          scheduled_for?: string;
          status?: string;
          subject_id?: string;
          updated_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "spaced_repetition_schedule_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "spaced_repetition_schedule_failed_attempt_id_fkey";
            columns: ["failed_attempt_id"];
            isOneToOne: false;
            referencedRelation: "attempts";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "spaced_repetition_schedule_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
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
          content_language: string;
          description: string | null;
          display_order: number;
          grade_id: string | null;
          icon: string;
          id: string;
          is_premium: boolean;
          name_fr: string;
          theme_id: string;
        };
        Insert: {
          attribute: string;
          color_token: string;
          content_language?: string;
          description?: string | null;
          display_order?: number;
          grade_id?: string | null;
          icon: string;
          id: string;
          is_premium?: boolean;
          name_fr: string;
          theme_id: string;
        };
        Update: {
          attribute?: string;
          color_token?: string;
          content_language?: string;
          description?: string | null;
          display_order?: number;
          grade_id?: string | null;
          icon?: string;
          id?: string;
          is_premium?: boolean;
          name_fr?: string;
          theme_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "subjects_grade_id_fkey";
            columns: ["grade_id"];
            isOneToOne: false;
            referencedRelation: "grades";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "subjects_theme_id_fkey";
            columns: ["theme_id"];
            isOneToOne: false;
            referencedRelation: "themes";
            referencedColumns: ["id"];
          },
        ];
      };
      themes: {
        Row: {
          color_token: string;
          content_language: string;
          description: string | null;
          display_order: number;
          has_grades: boolean;
          icon: string;
          id: string;
          name_fr: string;
        };
        Insert: {
          color_token: string;
          content_language?: string;
          description?: string | null;
          display_order?: number;
          has_grades?: boolean;
          icon: string;
          id: string;
          name_fr: string;
        };
        Update: {
          color_token?: string;
          content_language?: string;
          description?: string | null;
          display_order?: number;
          has_grades?: boolean;
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
      weekly_quests: {
        Row: {
          coin_reward: number;
          completed_at: string | null;
          created_at: string;
          current_value: number;
          id: string;
          quest_type: string;
          status: string;
          subject_id: string | null;
          target_value: number;
          user_id: string;
          week_start_date: string;
          xp_reward: number;
        };
        Insert: {
          coin_reward?: number;
          completed_at?: string | null;
          created_at?: string;
          current_value?: number;
          id?: string;
          quest_type: string;
          status?: string;
          subject_id?: string | null;
          target_value: number;
          user_id: string;
          week_start_date: string;
          xp_reward?: number;
        };
        Update: {
          coin_reward?: number;
          completed_at?: string | null;
          created_at?: string;
          current_value?: number;
          id?: string;
          quest_type?: string;
          status?: string;
          subject_id?: string | null;
          target_value?: number;
          user_id?: string;
          week_start_date?: string;
          xp_reward?: number;
        };
        Relationships: [
          {
            foreignKeyName: "weekly_quests_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
    };
    Views: {
      daily_objective_summary: {
        Row: {
          completed_objectives: number | null;
          objective_date: string | null;
          total_objectives: number | null;
          user_id: string | null;
          xp_earned: number | null;
        };
        Relationships: [];
      };
      subject_leaderboard_totals: {
        Row: {
          subject_id: string | null;
          subject_xp: number | null;
          user_id: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "attempts_subject_id_fkey";
            columns: ["subject_id"];
            isOneToOne: false;
            referencedRelation: "subjects";
            referencedColumns: ["id"];
          },
        ];
      };
      weekly_quest_summary: {
        Row: {
          completed_quests: number | null;
          total_quests: number | null;
          user_id: string | null;
          week_start_date: string | null;
          xp_earned: number | null;
        };
        Relationships: [];
      };
    };
    Functions: {
      activate_inventory_item: { Args: { p_item_code: string }; Returns: Json };
      admin_grant_parcours: {
        Args: {
          p_expires_at?: string;
          p_parcours: string;
          p_source?: string;
          p_user: string;
        };
        Returns: undefined;
      };
      admin_list_beta_requests: {
        Args: never;
        Returns: {
          created_at: string;
          email: string;
          id: string;
          motivation: string;
          name: string;
          reviewed_at: string;
          status: string;
          user_id: string;
        }[];
      };
      admin_list_content_reports: {
        Args: never;
        Returns: {
          created_at: string;
          exercise_id: string;
          exercise_title: string;
          id: string;
          message: string;
          question_id: string;
          status: string;
          subject_id: string;
        }[];
      };
      admin_list_parcours_entitlements: {
        Args: never;
        Returns: {
          display_name: string;
          email: string;
          expires_at: string;
          granted_at: string;
          is_active: boolean;
          parcours_id: string;
          parcours_name: string;
          source: string;
          user_id: string;
        }[];
      };
      admin_open_reports_count: { Args: never; Returns: number };
      admin_pending_beta_count: { Args: never; Returns: number };
      admin_resolve_content_report: {
        Args: { p_report: string; p_status: string };
        Returns: undefined;
      };
      admin_review_beta_request: {
        Args: { p_approve: boolean; p_request: string };
        Returns: undefined;
      };
      admin_revoke_parcours: {
        Args: { p_parcours: string; p_user: string };
        Returns: undefined;
      };
      award_badge_if_new: {
        Args: { p_badge_code: string; p_reason: string; p_user: string };
        Returns: Json;
      };
      award_coins: {
        Args: { p_coins: number; p_user: string };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
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
      award_xp: {
        Args: { p_user: string; p_xp: number };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
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
      check_rate_limit: {
        Args: { p_key: string; p_max_requests: number; p_window_ms: number };
        Returns: boolean;
      };
      cleanup_rate_limit_events: {
        Args: { p_retention_hours?: number };
        Returns: number;
      };
      consume_hint: { Args: { p_question_id: string }; Returns: Json };
      ensure_daily_weekly_goals: {
        Args: { p_user: string };
        Returns: undefined;
      };
      equip_inventory_skin: { Args: { p_item_code: string }; Returns: Json };
      finalize_dungeon_run: {
        Args: { p_duration_seconds: number; p_run_id: string };
        Returns: Json;
      };
      get_best_scores_by_exercise: {
        Args: { p_subject: string };
        Returns: {
          best_score: number;
          exercise_id: string;
        }[];
      };
      get_dungeon_access: {
        Args: never;
        Returns: {
          can_access: boolean;
          chapters_done: number;
          has_subscription: boolean;
          level: number;
          max_runs_per_day: number;
          reason: string;
          required_chapters: number;
          required_subjects: number;
          runs_today: number;
          subjects_done: number;
        }[];
      };
      get_dungeon_questions: {
        Args: { p_batch_size?: number; p_run_id: string };
        Returns: Json;
      };
      get_student_report: { Args: { p_student: string }; Returns: Json };
      get_subject_leaderboard: {
        Args: { p_limit?: number; p_subject: string };
        Returns: {
          avatar_tier: number;
          current_streak: number;
          display_name: string;
          hero_class: string;
          is_me: boolean;
          level: number;
          rank: number;
          subject_xp: number;
        }[];
      };
      has_parcours_entitlement: {
        Args: { p_parcours: string; p_user: string };
        Returns: boolean;
      };
      has_parcours_entitlement_for_subject: {
        Args: { p_subject: string; p_user: string };
        Returns: boolean;
      };
      is_admin: { Args: never; Returns: boolean };
      is_parent_of_student: {
        Args: { p_parent: string; p_student: string };
        Returns: boolean;
      };
      link_student_by_code: {
        Args: { p_code: string; p_relation?: string };
        Returns: Json;
      };
      purchase_shop_item: { Args: { p_item_code: string }; Returns: Json };
      resolve_exercise_access: {
        Args: { p_exercise: string };
        Returns: {
          allowed: boolean;
          has_entitlement: boolean;
          is_premium: boolean;
          is_preview: boolean;
          parcours_id: string;
          parcours_name: string;
          reason: string;
        }[];
      };
      resolve_subject_parcours: {
        Args: { p_grade: string; p_theme: string };
        Returns: string;
      };
      set_current_parcours: {
        Args: { p_parcours: string };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
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
      set_profile_role: {
        Args: { p_role: string };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
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
      spend_coins: {
        Args: { p_coins: number; p_user: string };
        Returns: {
          avatar_slug: string | null;
          avatar_tier: number;
          bosses_defeated: number;
          created_at: string;
          current_grade_id: string | null;
          current_parcours_id: string | null;
          current_streak: number;
          display_name: string;
          hero_class: string;
          id: string;
          last_active_date: string | null;
          level: number;
          longest_streak: number;
          role: string;
          total_time_minutes: number;
          weekly_objectives_completed: number;
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
      start_dungeon_run: { Args: never; Returns: string };
      submit_dungeon_answer: {
        Args: { p_choice: string; p_question_id: string; p_run_id: string };
        Returns: Json;
      };
      submit_exercise_attempt: {
        Args: { p_answers: Json; p_exercise_id: string; p_session_id: string };
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
  public: {
    Enums: {},
  },
} as const;
