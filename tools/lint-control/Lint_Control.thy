theory Lint_Control imports Main begin

(* Isolated negative control: a fully proved but unnamed global simp lemma. *)
lemma [simp]: "True" by simp

end
