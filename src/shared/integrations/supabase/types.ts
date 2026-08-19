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
      _backup_subscriptions_20260609: {
        Row: {
          id: string | null;
          subscription_activated_at: string | null;
          subscription_expires_at: string | null;
          subscription_type: string | null;
        };
        Insert: {
          id?: string | null;
          subscription_activated_at?: string | null;
          subscription_expires_at?: string | null;
          subscription_type?: string | null;
        };
        Update: {
          id?: string | null;
          subscription_activated_at?: string | null;
          subscription_expires_at?: string | null;
          subscription_type?: string | null;
        };
        Relationships: [];
      };
      attempts: {
        Row: {
          completed_at: string;
          correct_count: number;
          duration_seconds: number;
          exercise_id: string;
          id: string;
          score_pct: number;
          session_id: string | null;
          subject_id: string;
          total_count: number;
          user_id: string;
          variant: string;
          xp_earned: number;
        };
        Insert: {
          completed_at?: string;
          correct_count: number;
          duration_seconds: number;
          exercise_id: string;
          id?: string;
          score_pct: number;
          session_id?: string | null;
          subject_id: string;
          total_count: number;
          user_id: string;
          variant?: string;
          xp_earned: number;
        };
        Update: {
          completed_at?: string;
          correct_count?: number;
          duration_seconds?: number;
          exercise_id?: string;
          id?: string;
          score_pct?: number;
          session_id?: string | null;
          subject_id?: string;
          total_count?: number;
          user_id?: string;
          variant?: string;
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
            foreignKeyName: "attempts_session_id_fkey";
            columns: ["session_id"];
            isOneToOne: false;
            referencedRelation: "exercise_sessions";
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
      bug_reports: {
        Row: {
          created_at: string;
          id: string;
          message: string;
          page: string | null;
          resolved_at: string | null;
          resolved_by: string | null;
          status: string;
          user_id: string;
        };
        Insert: {
          created_at?: string;
          id?: string;
          message: string;
          page?: string | null;
          resolved_at?: string | null;
          resolved_by?: string | null;
          status?: string;
          user_id: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          message?: string;
          page?: string | null;
          resolved_at?: string | null;
          resolved_by?: string | null;
          status?: string;
          user_id?: string;
        };
        Relationships: [];
      };
      chapters: {
        Row: {
          description: string | null;
          display_order: number;
          domain: string | null;
          id: string;
          lesson_content: string | null;
          manuel_ref: Json | null;
          subject_id: string;
          summary: string | null;
          title: string;
          videos: Json;
        };
        Insert: {
          description?: string | null;
          display_order?: number;
          domain?: string | null;
          id?: string;
          lesson_content?: string | null;
          manuel_ref?: Json | null;
          subject_id: string;
          summary?: string | null;
          title: string;
          videos?: Json;
        };
        Update: {
          description?: string | null;
          display_order?: number;
          domain?: string | null;
          id?: string;
          lesson_content?: string | null;
          manuel_ref?: Json | null;
          subject_id?: string;
          summary?: string | null;
          title?: string;
          videos?: Json;
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
      competencies: {
        Row: {
          family: string;
          id: string;
          label_ar: string;
          label_en: string;
          label_fr: string;
          slug: string;
        };
        Insert: {
          family: string;
          id: string;
          label_ar: string;
          label_en: string;
          label_fr: string;
          slug: string;
        };
        Update: {
          family?: string;
          id?: string;
          label_ar?: string;
          label_en?: string;
          label_fr?: string;
          slug?: string;
        };
        Relationships: [];
      };
      competency_prereqs: {
        Row: {
          competency_id: string;
          prereq_id: string;
        };
        Insert: {
          competency_id: string;
          prereq_id: string;
        };
        Update: {
          competency_id?: string;
          prereq_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "competency_prereqs_competency_id_fkey";
            columns: ["competency_id"];
            isOneToOne: false;
            referencedRelation: "competencies";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "competency_prereqs_prereq_id_fkey";
            columns: ["prereq_id"];
            isOneToOne: false;
            referencedRelation: "competencies";
            referencedColumns: ["id"];
          },
        ];
      };
      content_releases: {
        Row: {
          actor: string;
          applied_at: string;
          git_sha: string;
          id: string;
          subjects: string[];
        };
        Insert: {
          actor: string;
          applied_at?: string;
          git_sha: string;
          id?: string;
          subjects?: string[];
        };
        Update: {
          actor?: string;
          applied_at?: string;
          git_sha?: string;
          id?: string;
          subjects?: string[];
        };
        Relationships: [];
      };
      content_reports: {
        Row: {
          created_at: string;
          exercise_id: string | null;
          id: string;
          kind: string;
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
          kind?: string;
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
          kind?: string;
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
      duel_league_awards: {
        Row: {
          awarded_at: string;
          coins_awarded: number;
          points: number;
          rank: number;
          tier: string;
          user_id: string;
          week_start: string;
        };
        Insert: {
          awarded_at?: string;
          coins_awarded: number;
          points: number;
          rank: number;
          tier: string;
          user_id: string;
          week_start: string;
        };
        Update: {
          awarded_at?: string;
          coins_awarded?: number;
          points?: number;
          rank?: number;
          tier?: string;
          user_id?: string;
          week_start?: string;
        };
        Relationships: [];
      };
      duel_participants: {
        Row: {
          answers_submitted_at: string[];
          duel_id: string;
          finished_at: string | null;
          rewarded_at: string | null;
          score: number;
          user_id: string;
        };
        Insert: {
          answers_submitted_at?: string[];
          duel_id: string;
          finished_at?: string | null;
          rewarded_at?: string | null;
          score?: number;
          user_id: string;
        };
        Update: {
          answers_submitted_at?: string[];
          duel_id?: string;
          finished_at?: string | null;
          rewarded_at?: string | null;
          score?: number;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "duel_participants_duel_id_fkey";
            columns: ["duel_id"];
            isOneToOne: false;
            referencedRelation: "duels";
            referencedColumns: ["id"];
          },
        ];
      };
      duel_queue: {
        Row: {
          enqueued_at: string;
          grade_id: string | null;
          parcours_id: string;
          user_id: string;
        };
        Insert: {
          enqueued_at?: string;
          grade_id?: string | null;
          parcours_id: string;
          user_id: string;
        };
        Update: {
          enqueued_at?: string;
          grade_id?: string | null;
          parcours_id?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "duel_queue_grade_id_fkey";
            columns: ["grade_id"];
            isOneToOne: false;
            referencedRelation: "grades";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "duel_queue_parcours_id_fkey";
            columns: ["parcours_id"];
            isOneToOne: false;
            referencedRelation: "parcours";
            referencedColumns: ["id"];
          },
        ];
      };
      duels: {
        Row: {
          created_at: string;
          exercise_source: string;
          expires_at: string;
          id: string;
          parcours_id: string;
          question_ids: string[];
          status: string;
        };
        Insert: {
          created_at?: string;
          exercise_source?: string;
          expires_at: string;
          id?: string;
          parcours_id: string;
          question_ids: string[];
          status?: string;
        };
        Update: {
          created_at?: string;
          exercise_source?: string;
          expires_at?: string;
          id?: string;
          parcours_id?: string;
          question_ids?: string[];
          status?: string;
        };
        Relationships: [
          {
            foreignKeyName: "duels_parcours_id_fkey";
            columns: ["parcours_id"];
            isOneToOne: false;
            referencedRelation: "parcours";
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
          variant: string;
        };
        Insert: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id: string;
          id?: string;
          started_at?: string;
          user_id: string;
          variant?: string;
        };
        Update: {
          completed_at?: string | null;
          created_at?: string;
          exercise_id?: string;
          id?: string;
          started_at?: string;
          user_id?: string;
          variant?: string;
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
          correction_video: Json | null;
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
          correction_video?: Json | null;
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
          correction_video?: Json | null;
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
          is_selectable: boolean;
          name_fr: string;
          slug: string;
          theme_id: string;
        };
        Insert: {
          cycle?: string | null;
          display_order?: number;
          id?: string;
          is_concours_national?: boolean;
          is_selectable?: boolean;
          name_fr: string;
          slug: string;
          theme_id: string;
        };
        Update: {
          cycle?: string | null;
          display_order?: number;
          id?: string;
          is_concours_national?: boolean;
          is_selectable?: boolean;
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
      learning_pulses: {
        Row: {
          active_seconds: number;
          chapter_id: string | null;
          exercise_id: string | null;
          id: number;
          occurred_at: string;
          progress_pct: number | null;
          subject_id: string | null;
          surface: string;
          user_id: string;
        };
        Insert: {
          active_seconds: number;
          chapter_id?: string | null;
          exercise_id?: string | null;
          id?: never;
          occurred_at?: string;
          progress_pct?: number | null;
          subject_id?: string | null;
          surface: string;
          user_id: string;
        };
        Update: {
          active_seconds?: number;
          chapter_id?: string | null;
          exercise_id?: string | null;
          id?: never;
          occurred_at?: string;
          progress_pct?: number | null;
          subject_id?: string | null;
          surface?: string;
          user_id?: string;
        };
        Relationships: [];
      };
      misconceptions: {
        Row: {
          competency: string | null;
          label_ar: string;
          label_en: string;
          label_fr: string;
          subject: string;
          tag: string;
        };
        Insert: {
          competency?: string | null;
          label_ar: string;
          label_en: string;
          label_fr: string;
          subject: string;
          tag: string;
        };
        Update: {
          competency?: string | null;
          label_ar?: string;
          label_en?: string;
          label_fr?: string;
          subject?: string;
          tag?: string;
        };
        Relationships: [];
      };
      mock_exam_papers: {
        Row: {
          display_order: number;
          exam_id: string;
          exercise_id: string;
          label_ar: string | null;
          label_en: string | null;
          label_fr: string;
          points: number;
        };
        Insert: {
          display_order: number;
          exam_id: string;
          exercise_id: string;
          label_ar?: string | null;
          label_en?: string | null;
          label_fr: string;
          points: number;
        };
        Update: {
          display_order?: number;
          exam_id?: string;
          exercise_id?: string;
          label_ar?: string | null;
          label_en?: string | null;
          label_fr?: string;
          points?: number;
        };
        Relationships: [
          {
            foreignKeyName: "mock_exam_papers_exam_id_fkey";
            columns: ["exam_id"];
            isOneToOne: false;
            referencedRelation: "mock_exams";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "mock_exam_papers_exercise_id_fkey";
            columns: ["exercise_id"];
            isOneToOne: false;
            referencedRelation: "exercises";
            referencedColumns: ["id"];
          },
        ];
      };
      mock_exam_sessions: {
        Row: {
          answers: Json;
          deadline: string;
          exam_id: string;
          finished_at: string | null;
          id: string;
          kind: string;
          max_points: number | null;
          score_points: number | null;
          started_at: string;
          user_id: string;
        };
        Insert: {
          answers?: Json;
          deadline: string;
          exam_id: string;
          finished_at?: string | null;
          id?: string;
          kind?: string;
          max_points?: number | null;
          score_points?: number | null;
          started_at?: string;
          user_id: string;
        };
        Update: {
          answers?: Json;
          deadline?: string;
          exam_id?: string;
          finished_at?: string | null;
          id?: string;
          kind?: string;
          max_points?: number | null;
          score_points?: number | null;
          started_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "mock_exam_sessions_exam_id_fkey";
            columns: ["exam_id"];
            isOneToOne: false;
            referencedRelation: "mock_exams";
            referencedColumns: ["id"];
          },
        ];
      };
      mock_exams: {
        Row: {
          created_at: string;
          display_order: number;
          duration_minutes: number;
          id: string;
          parcours_id: string;
          status: string;
          title_ar: string | null;
          title_en: string | null;
          title_fr: string;
        };
        Insert: {
          created_at?: string;
          display_order?: number;
          duration_minutes: number;
          id?: string;
          parcours_id: string;
          status?: string;
          title_ar?: string | null;
          title_en?: string | null;
          title_fr: string;
        };
        Update: {
          created_at?: string;
          display_order?: number;
          duration_minutes?: number;
          id?: string;
          parcours_id?: string;
          status?: string;
          title_ar?: string | null;
          title_en?: string | null;
          title_fr?: string;
        };
        Relationships: [
          {
            foreignKeyName: "mock_exams_parcours_id_fkey";
            columns: ["parcours_id"];
            isOneToOne: false;
            referencedRelation: "parcours";
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
      parcours_interest: {
        Row: {
          created_at: string;
          id: string;
          parcours_id: string;
          user_id: string;
        };
        Insert: {
          created_at?: string;
          id?: string;
          parcours_id: string;
          user_id: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          parcours_id?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "parcours_interest_parcours_id_fkey";
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
      parent_weekly_goals: {
        Row: {
          created_at: string;
          id: string;
          parent_user_id: string;
          student_user_id: string;
          target_exercises: number;
          updated_at: string;
          week_start: string;
        };
        Insert: {
          created_at?: string;
          id?: string;
          parent_user_id: string;
          student_user_id: string;
          target_exercises: number;
          updated_at?: string;
          week_start: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          parent_user_id?: string;
          student_user_id?: string;
          target_exercises?: number;
          updated_at?: string;
          week_start?: string;
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
          current_parcours_set_at: string | null;
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
          current_parcours_set_at?: string | null;
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
          current_parcours_set_at?: string | null;
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
      push_subscriptions: {
        Row: {
          auth: string;
          created_at: string;
          endpoint: string;
          failure_count: number;
          id: string;
          last_success_at: string | null;
          p256dh: string;
          user_agent: string | null;
          user_id: string;
        };
        Insert: {
          auth: string;
          created_at?: string;
          endpoint: string;
          failure_count?: number;
          id?: string;
          last_success_at?: string | null;
          p256dh: string;
          user_agent?: string | null;
          user_id: string;
        };
        Update: {
          auth?: string;
          created_at?: string;
          endpoint?: string;
          failure_count?: number;
          id?: string;
          last_success_at?: string | null;
          p256dh?: string;
          user_agent?: string | null;
          user_id?: string;
        };
        Relationships: [];
      };
      question_attempts: {
        Row: {
          chapter_id: string;
          choice: string;
          created_at: string;
          id: number;
          is_correct: boolean;
          misconception_tag: string | null;
          question_id: string;
          session_id: string;
          source: string;
          user_id: string;
        };
        Insert: {
          chapter_id: string;
          choice: string;
          created_at?: string;
          id?: never;
          is_correct: boolean;
          misconception_tag?: string | null;
          question_id: string;
          session_id: string;
          source: string;
          user_id: string;
        };
        Update: {
          chapter_id?: string;
          choice?: string;
          created_at?: string;
          id?: never;
          is_correct?: boolean;
          misconception_tag?: string | null;
          question_id?: string;
          session_id?: string;
          source?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "question_attempts_question_id_fkey";
            columns: ["question_id"];
            isOneToOne: false;
            referencedRelation: "questions";
            referencedColumns: ["id"];
          },
        ];
      };
      question_competencies: {
        Row: {
          competency_id: string;
          is_primary: boolean;
          question_id: string;
        };
        Insert: {
          competency_id: string;
          is_primary?: boolean;
          question_id: string;
        };
        Update: {
          competency_id?: string;
          is_primary?: boolean;
          question_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "question_competencies_competency_id_fkey";
            columns: ["competency_id"];
            isOneToOne: false;
            referencedRelation: "competencies";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "question_competencies_question_id_fkey";
            columns: ["question_id"];
            isOneToOne: false;
            referencedRelation: "questions";
            referencedColumns: ["id"];
          },
        ];
      };
      questions: {
        Row: {
          accepted_answers: Json;
          answer_key: Json | null;
          correct_option: string | null;
          display_order: number;
          distractor_tags: Json | null;
          exercise_id: string;
          explanation: string | null;
          id: string;
          options: Json;
          prompt: string;
          question_type: string;
        };
        Insert: {
          accepted_answers?: Json;
          answer_key?: Json | null;
          correct_option?: string | null;
          display_order?: number;
          distractor_tags?: Json | null;
          exercise_id: string;
          explanation?: string | null;
          id?: string;
          options: Json;
          prompt: string;
          question_type?: string;
        };
        Update: {
          accepted_answers?: Json;
          answer_key?: Json | null;
          correct_option?: string | null;
          display_order?: number;
          distractor_tags?: Json | null;
          exercise_id?: string;
          explanation?: string | null;
          id?: string;
          options?: Json;
          prompt?: string;
          question_type?: string;
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
          manuel_refs: Json | null;
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
          manuel_refs?: Json | null;
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
          manuel_refs?: Json | null;
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
      user_competency_mastery: {
        Row: {
          attempts: number;
          competency_id: string;
          last_attempt_at: string;
          mastery: number;
          user_id: string;
        };
        Insert: {
          attempts?: number;
          competency_id: string;
          last_attempt_at: string;
          mastery?: number;
          user_id: string;
        };
        Update: {
          attempts?: number;
          competency_id?: string;
          last_attempt_at?: string;
          mastery?: number;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "user_competency_mastery_competency_id_fkey";
            columns: ["competency_id"];
            isOneToOne: false;
            referencedRelation: "competencies";
            referencedColumns: ["id"];
          },
        ];
      };
      user_misconceptions: {
        Row: {
          last_seen_at: string;
          occurrences: number;
          sessions_seen: number;
          tag: string;
          user_id: string;
        };
        Insert: {
          last_seen_at: string;
          occurrences?: number;
          sessions_seen?: number;
          tag: string;
          user_id: string;
        };
        Update: {
          last_seen_at?: string;
          occurrences?: number;
          sessions_seen?: number;
          tag?: string;
          user_id?: string;
        };
        Relationships: [];
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
      econ_coin_flows_30d: {
        Row: {
          sink_ratio: number | null;
          sinks_shop: number | null;
          sources_earned: number | null;
        };
        Relationships: [];
      };
      econ_consumables: {
        Row: {
          acquired: number | null;
          code: string | null;
          consumed: number | null;
          holders: number | null;
          item_type: string | null;
          name: string | null;
          price_coins: number | null;
          still_armed: number | null;
        };
        Relationships: [];
      };
      econ_level_velocity: {
        Row: {
          days_to_reach: number | null;
          level_reached: number | null;
          user_id: string | null;
        };
        Relationships: [];
      };
      econ_premium_funnel: {
        Row: {
          active_30d: number | null;
          active_entitled: number | null;
          entitled_total: number | null;
          premium_parcours: number | null;
        };
        Relationships: [];
      };
      econ_xp_daily: {
        Row: {
          attempts: number | null;
          day: string | null;
          user_id: string | null;
          xp_earned: number | null;
        };
        Relationships: [];
      };
      global_leaderboard_ranked: {
        Row: {
          rank: number | null;
          user_id: string | null;
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
      _daily_report_with_scopes: {
        Args: {
          p_from: string;
          p_scope: string;
          p_student: string;
          p_to: string;
        };
        Returns: Json;
      };
      _scope_subject_ids: {
        Args: { p_scope: string; p_student: string };
        Returns: string[];
      };
      _scoped_attempts: {
        Args: {
          p_from: string;
          p_student: string;
          p_subject_ids: string[];
          p_to: string;
        };
        Returns: {
          completed_at: string;
          correct_count: number;
          duration_seconds: number;
          exercise_id: string;
          id: string;
          score_pct: number;
          session_id: string | null;
          subject_id: string;
          total_count: number;
          user_id: string;
          variant: string;
          xp_earned: number;
        }[];
        SetofOptions: {
          from: "*";
          to: "attempts";
          isOneToOne: false;
          isSetofReturn: true;
        };
      };
      _scoped_pulses: {
        Args: {
          p_from: string;
          p_student: string;
          p_subject_ids: string[];
          p_to: string;
        };
        Returns: {
          active_seconds: number;
          chapter_id: string | null;
          exercise_id: string | null;
          id: number;
          occurred_at: string;
          progress_pct: number | null;
          subject_id: string | null;
          surface: string;
          user_id: string;
        }[];
        SetofOptions: {
          from: "*";
          to: "learning_pulses";
          isOneToOne: false;
          isSetofReturn: true;
        };
      };
      _student_activity_scopes: { Args: { p_student: string }; Returns: Json };
      _student_attempt_detail_json: {
        Args: { p_attempt: string; p_student: string };
        Returns: Json;
      };
      _student_class_subject_ids: {
        Args: { p_student: string };
        Returns: string[];
      };
      _student_daily_report_json: {
        Args: {
          p_from: string;
          p_student: string;
          p_subject_ids?: string[];
          p_to: string;
        };
        Returns: Json;
      };
      _student_id_from_alliance_code: {
        Args: { p_code: string };
        Returns: string;
      };
      _student_report_json: { Args: { p_student: string }; Returns: Json };
      activate_inventory_item: { Args: { p_item_code: string }; Returns: Json };
      admin_economy_overview: { Args: never; Returns: Json };
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
      admin_list_bug_reports: {
        Args: never;
        Returns: {
          created_at: string;
          id: string;
          message: string;
          page: string;
          status: string;
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
      admin_open_bugs_count: { Args: never; Returns: number };
      admin_open_reports_count: { Args: never; Returns: number };
      admin_pending_beta_count: { Args: never; Returns: number };
      admin_resolve_bug_report: {
        Args: { p_report: string; p_status: string };
        Returns: undefined;
      };
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
      answer_key_display: {
        Args: { q: Database["public"]["Tables"]["questions"]["Row"] };
        Returns: string;
      };
      app_current_week_start: { Args: never; Returns: string };
      assert_can_read_student_activity: {
        Args: { p_student: string };
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
          current_parcours_set_at: string | null;
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
      award_duel_league_week: { Args: { p_week?: string }; Returns: number };
      award_duel_rewards: {
        Args: { p_coins: number; p_user: string; p_xp: number };
        Returns: undefined;
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
          current_parcours_set_at: string | null;
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
      check_answers: {
        Args: { p_answers: Json; p_exercise_id: string };
        Returns: {
          correct_option: string;
          explanation: string;
          is_correct: boolean;
          question_id: string;
        }[];
      };
      check_rate_limit: {
        Args: { p_key: string; p_max_requests: number; p_window_ms: number };
        Returns: boolean;
      };
      cleanup_rate_limit_events: {
        Args: { p_retention_hours?: number };
        Returns: number;
      };
      competency_mastery_alpha: {
        Args: { p_difficulty: number };
        Returns: number;
      };
      competency_mastery_with_decay: {
        Args: { p_last_attempt_at: string; p_mastery: number };
        Returns: number;
      };
      consume_hint: { Args: { p_question_id: string }; Returns: Json };
      delete_push_subscription: {
        Args: { p_endpoint: string };
        Returns: undefined;
      };
      duel_league_standings: {
        Args: { p_week: string };
        Returns: {
          played: number;
          points: number;
          rank: number;
          total: number;
          user_id: string;
          wins: number;
        }[];
      };
      duel_league_tier: {
        Args: { p_rank: number; p_total: number };
        Returns: string;
      };
      duel_league_tier_coins: { Args: { p_tier: string }; Returns: number };
      ensure_daily_weekly_goals: {
        Args: { p_user: string };
        Returns: undefined;
      };
      equip_inventory_skin: { Args: { p_item_code: string }; Returns: Json };
      expire_duels: { Args: never; Returns: number };
      finalize_duel: { Args: { p_duel: string }; Returns: undefined };
      finalize_dungeon_run: {
        Args: { p_duration_seconds: number; p_run_id: string };
        Returns: Json;
      };
      finish_mock_exam: { Args: { p_session_id: string }; Returns: Json };
      forfeit_duel: { Args: { p_duel: string }; Returns: undefined };
      get_attempt_review: {
        Args: { p_answers?: Json; p_session_id: string };
        Returns: {
          chapter_id: string;
          correct_option: string;
          explanation: string;
          is_correct: boolean;
          misconception_tag: string;
          prompt: string;
          question_id: string;
        }[];
      };
      get_best_scores_by_exercise: {
        Args: { p_subject: string };
        Returns: {
          best_score: number;
          exercise_id: string;
        }[];
      };
      get_competency_blockers: {
        Args: { p_competency: string };
        Returns: {
          competency_id: string;
          depth: number;
          label_ar: string;
          label_en: string;
          label_fr: string;
          mastery: number;
          slug: string;
        }[];
      };
      get_daily_plan: {
        Args: { p_limit?: number };
        Returns: {
          chapter_id: string;
          chapter_title: string;
          days_overdue: number;
          exercise_id: string;
          exercise_title: string;
          is_fallback: boolean;
          subject_id: string;
          weak_tags: number;
        }[];
      };
      get_duel_league: {
        Args: { p_limit?: number };
        Returns: {
          avatar_tier: number;
          display_name: string;
          hero_class: string;
          is_me: boolean;
          played: number;
          points: number;
          rank: number;
          tier: string;
          wins: number;
        }[];
      };
      get_duel_state: { Args: { p_duel: string }; Returns: Json };
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
      get_exercises_for_competency: {
        Args: { p_competency: string };
        Returns: {
          chapter_id: string;
          difficulty: number;
          exercise_id: string;
          exercise_title: string;
          subject_id: string;
        }[];
      };
      get_family_weekly_goal: { Args: { p_student: string }; Returns: Json };
      get_global_leaderboard: {
        Args: { p_limit?: number };
        Returns: {
          avatar_tier: number;
          current_streak: number;
          display_name: string;
          hero_class: string;
          is_me: boolean;
          level: number;
          rank: number;
          xp: number;
        }[];
      };
      get_grade_leaderboard: {
        Args: { p_limit?: number };
        Returns: {
          avatar_tier: number;
          current_streak: number;
          display_name: string;
          hero_class: string;
          is_me: boolean;
          level: number;
          rank: number;
          xp: number;
        }[];
      };
      get_mock_exam_percentile: {
        Args: { p_session_id: string };
        Returns: Json;
      };
      get_mock_exam_review: { Args: { p_session_id: string }; Returns: Json };
      get_my_competency_map: {
        Args: { p_subject_family?: string };
        Returns: {
          attempts: number;
          competency_id: string;
          domain: string;
          family: string;
          label_ar: string;
          label_en: string;
          label_fr: string;
          mastery: number;
          recent_result: number;
          slug: string;
        }[];
      };
      get_recall_availability: {
        Args: { p_subject_id: string };
        Returns: {
          best_recall_pct: number;
          eligible_count: number;
          exercise_id: string;
          unlocked: boolean;
        }[];
      };
      get_recall_questions: {
        Args: { p_exercise_id: string };
        Returns: {
          display_order: number;
          id: string;
          prompt: string;
        }[];
      };
      get_student_attempt_detail: {
        Args: { p_attempt: string; p_student: string };
        Returns: Json;
      };
      get_student_attempt_detail_by_code: {
        Args: { p_attempt: string; p_code: string };
        Returns: Json;
      };
      get_student_daily_report:
        | {
            Args: { p_from: string; p_student: string; p_to: string };
            Returns: Json;
          }
        | {
            Args: {
              p_from: string;
              p_scope: string;
              p_student: string;
              p_to: string;
            };
            Returns: Json;
          };
      get_student_daily_report_by_code:
        | {
            Args: { p_code: string; p_from: string; p_to: string };
            Returns: Json;
          }
        | {
            Args: {
              p_code: string;
              p_from: string;
              p_scope: string;
              p_to: string;
            };
            Returns: Json;
          };
      get_student_report: { Args: { p_student: string }; Returns: Json };
      get_student_report_by_code: { Args: { p_code: string }; Returns: Json };
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
      get_user_parcours_progress: {
        Args: { p_subject_ids?: string[] };
        Returns: {
          chapters_completed: number;
          chapters_total: number;
          subject_id: string;
        }[];
      };
      get_user_subject_stats: {
        Args: never;
        Returns: {
          attempts_count: number;
          avg_score: number;
          subject_id: string;
          total_xp: number;
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
      is_accepted_free_answer: {
        Args: {
          p_choice: string;
          q: Database["public"]["Tables"]["questions"]["Row"];
        };
        Returns: boolean;
      };
      is_admin: { Args: never; Returns: boolean };
      is_duel_participant: {
        Args: { p_duel: string; p_user: string };
        Returns: boolean;
      };
      is_parent_of_student: {
        Args: { p_parent: string; p_student: string };
        Returns: boolean;
      };
      is_question_recall_eligible: {
        Args: { q: Database["public"]["Tables"]["questions"]["Row"] };
        Returns: boolean;
      };
      link_student_by_code: {
        Args: { p_code: string; p_relation?: string };
        Returns: Json;
      };
      list_mock_exams: { Args: { p_parcours_id?: string }; Returns: Json };
      match_duel: { Args: never; Returns: string };
      normalize_recall_text: { Args: { p: string }; Returns: string };
      parcours_interest_counts: {
        Args: never;
        Returns: {
          interest_count: number;
          name_fr: string;
          parcours_id: string;
        }[];
      };
      purchase_shop_item: { Args: { p_item_code: string }; Returns: Json };
      purge_learning_pulses: { Args: never; Returns: undefined };
      purge_question_attempts: { Args: never; Returns: number };
      record_learning_pulse: {
        Args: {
          p_active_seconds: number;
          p_chapter?: string;
          p_exercise?: string;
          p_progress_pct?: number;
          p_subject?: string;
          p_surface: string;
        };
        Returns: number;
      };
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
      resolve_misconception_tag: {
        Args: {
          p_choice: string;
          p_variant?: string;
          q: Database["public"]["Tables"]["questions"]["Row"];
        };
        Returns: string;
      };
      resolve_subject_parcours: {
        Args: { p_grade: string; p_theme: string };
        Returns: string;
      };
      save_mock_answers: {
        Args: { p_answers: Json; p_session_id: string };
        Returns: Json;
      };
      save_push_subscription: {
        Args: {
          p_auth: string;
          p_endpoint: string;
          p_p256dh: string;
          p_user_agent?: string;
        };
        Returns: undefined;
      };
      score_answer: {
        Args: {
          p_choice: string;
          q: Database["public"]["Tables"]["questions"]["Row"];
        };
        Returns: boolean;
      };
      score_quiz: {
        Args: { p_answers: Json; p_exercise_id: string };
        Returns: {
          correct: number;
          total: number;
        }[];
      };
      score_recall_answer: {
        Args: {
          p_choice: string;
          q: Database["public"]["Tables"]["questions"]["Row"];
        };
        Returns: boolean;
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
          current_parcours_set_at: string | null;
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
      set_parent_weekly_goal: {
        Args: { p_student: string; p_target: number };
        Returns: Json;
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
          current_parcours_set_at: string | null;
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
          current_parcours_set_at: string | null;
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
      start_exercise_session: {
        Args: { p_exercise_id: string; p_variant?: string };
        Returns: {
          session_id: string;
          started_at: string;
        }[];
      };
      start_mock_exam: {
        Args: { p_exam_id: string; p_kind?: string };
        Returns: Json;
      };
      student_activity_totals: {
        Args: {
          p_from: string;
          p_pass_pct: number;
          p_session_gap: string;
          p_student: string;
          p_studied_pct: number;
          p_studied_seconds: number;
          p_subject_ids?: string[];
          p_to: string;
          p_tz: string;
        };
        Returns: Json;
      };
      student_parcours_progress: {
        Args: { p_subject_ids?: string[]; p_user: string };
        Returns: {
          chapters_completed: number;
          chapters_total: number;
          subject_id: string;
        }[];
      };
      submit_duel_answer: {
        Args: { p_choice: string; p_duel: string; p_question: string };
        Returns: Json;
      };
      submit_dungeon_answer: {
        Args: { p_choice: string; p_question_id: string; p_run_id: string };
        Returns: Json;
      };
      submit_exercise_attempt: {
        Args: { p_answers: Json; p_exercise_id: string; p_session_id: string };
        Returns: Json;
      };
      toggle_parcours_interest: {
        Args: { p_parcours: string };
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
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
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
    keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
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
    keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
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
    keyof DefaultSchema["Enums"] | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    keyof DefaultSchema["CompositeTypes"] | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
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
