(* Authors: Arthur Freitas Ramos, David Barros Hulak,
   Ruy Jose Guerra Barretto de Queiroz *)

section \<open>Monotone--light factorization\<close>

theory Monotone_Light
  imports "Topological_Groups.Topological_Group"
    "HOL-Analysis.Abstract_Topological_Spaces" "HOL-Analysis.Urysohn"
begin

definition fibre_component :: "'a topology \<Rightarrow> ('a \<Rightarrow> 'b) \<Rightarrow> 'a \<Rightarrow> 'a set" where
  "fibre_component X f x =
    connected_component_of_set (subtopology X {z \<in> topspace X. f z = f x}) x"

definition component_quotient where
  "component_quotient X f = quot_topology X (fibre_component X f)"

definition light_map where
  "light_map X Y f \<longleftrightarrow> f ` topspace X \<subseteq> topspace Y \<and>
    (\<forall>y C. connectedin X C \<longrightarrow> C \<subseteq> {x \<in> topspace X. f x = y}
      \<longrightarrow> (\<forall>a\<in>C. \<forall>b\<in>C. a = b))"

lemma fibre_component_subset:
  "fibre_component X f x \<subseteq> {z \<in> topspace X. f z = f x}"
  using connected_component_of_subset_topspace
  unfolding fibre_component_def by fastforce

lemma fibre_component_self:
  "x \<in> topspace X \<Longrightarrow> x \<in> fibre_component X f x"
  unfolding fibre_component_def by (simp add: connected_component_of_refl)

lemma fibre_component_connected:
  "connectedin X (fibre_component X f x)"
  unfolding fibre_component_def
  using connectedin_connected_component_of[of
    "subtopology X {z \<in> topspace X. f z = f x}" x]
  by (simp add: connectedin_subtopology)

lemma fibre_component_eq:
  assumes "z \<in> fibre_component X f x"
  shows "fibre_component X f z = fibre_component X f x"
proof -
  have fx: "f z = f x"
    using assms fibre_component_subset[of X f x] by auto
  have "connected_component_of
    (subtopology X {z \<in> topspace X. f z = f x}) x z"
    using assms unfolding fibre_component_def by simp
  then have "connected_component_of
    (subtopology X {z \<in> topspace X. f z = f x}) x =
    connected_component_of (subtopology X {z \<in> topspace X. f z = f x}) z"
    using connected_component_of_equiv[of
      "subtopology X {z \<in> topspace X. f z = f x}" x z] by blast
  then show ?thesis
    unfolding fibre_component_def using fx by simp
qed

lemma fibre_component_fibre:
  assumes "x \<in> topspace X"
  shows "{z \<in> topspace X. fibre_component X f z = fibre_component X f x}
    = fibre_component X f x"
  using assms fibre_component_eq[of _ X f x]
    fibre_component_self[of _ X f] fibre_component_subset[of X f x] by blast

lemma component_quotient_map:
  "quotient_map X (component_quotient X f) (fibre_component X f)"
  by (simp add: component_quotient_def projection_quotient_map)

lemma component_quotient_topspace:
  "topspace (component_quotient X f) = fibre_component X f ` topspace X"
  by (simp add: component_quotient_def)

lemma component_quotient_monotone:
  "monotone_map X (component_quotient X f) (fibre_component X f)"
proof (unfold monotone_map_def, intro conjI ballI)
  show "fibre_component X f ` topspace X \<subseteq> topspace (component_quotient X f)"
    by (simp add: component_quotient_topspace)
next
  fix C assume "C \<in> topspace (component_quotient X f)"
  then obtain x where x: "x \<in> topspace X" "C = fibre_component X f x"
    by (auto simp: component_quotient_topspace)
  show "connectedin X {z \<in> topspace X. fibre_component X f z = C}"
    using fibre_component_fibre[OF x(1), of f]
    by (simp add: x(2) fibre_component_connected)
qed

text_raw \<open>\ProofNeedspace{8\baselineskip}\<close>
lemma fibre_component_closed:
  assumes "continuous_map X Y f" "Hausdorff_space Y"
  shows "closedin X (fibre_component X f x)"
proof -
  have "closedin X {z \<in> topspace X. f z = f x}"
  proof (cases "f x \<in> topspace Y")
    case True
    have "closedin Y {f x}"
      by (rule closedin_Hausdorff_singleton[OF assms(2) True])
    then show ?thesis
      using closedin_continuous_map_preimage[OF assms(1) \<open>closedin Y {f x}\<close>]
      by simp
  next
    case False
    have "{z \<in> topspace X. f z = f x} = {}"
      using continuous_map_image_subset_topspace[OF assms(1)] False by auto
    then show ?thesis by (metis closedin_empty)
  qed
  then show ?thesis
    unfolding fibre_component_def
    by (meson closedin_connected_component_of closedin_trans_full)
qed

text \<open>The main separation argument produces an open saturated neighbourhood.
Compact Hausdorff separation is central to this argument.\<close>

lemma fibre_component_avoiding_neighbourhood:
  assumes X: "compact_space X" "Hausdorff_space X"
    and f: "continuous_map X Y f" and Y: "Hausdorff_space Y"
    and A: "closedin X A" and x: "x \<in> topspace X"
    and dis: "disjnt (fibre_component X f x) A"
  obtains W where "openin X W" "x \<in> W" "disjnt W A"
    "\<And>z. z \<in> W \<Longrightarrow> fibre_component X f z \<subseteq> W"
proof -
  let ?F = "{z \<in> topspace X. f z = f x}"
  let ?T = "subtopology X ?F"
  have fx: "f x \<in> topspace Y"
    using f x continuous_map_image_subset_topspace by blast
  have F: "closedin X ?F"
    using closedin_continuous_map_preimage[OF f closedin_Hausdorff_singleton[OF Y fx]]
    by simp
  have T: "compact_space ?T" "Hausdorff_space ?T"
    using X F closedin_compact_space compact_space_subtopology
      Hausdorff_space_subtopology by blast+
  have qC: "fibre_component X f x \<in> quasi_components_of ?T"
    unfolding fibre_component_def
    using quasi_eq_connected_components_of[of ?T] T
      x by (simp add: connected_component_in_connected_components_of)
  have KA: "compactin ?T (?F \<inter> A)"
    using T A closedin_subtopology_Int_closed closedin_compact_space by blast
  have "separated_between ?T (fibre_component X f x) (?F \<inter> A)"
    using separated_between_quasi_component_compact[OF qC KA] dis
    by (auto simp: disjnt_iff)
  then obtain S where S: "closedin ?T S" "openin ?T S"
    "fibre_component X f x \<subseteq> S" "?F \<inter> A \<subseteq> topspace ?T - S"
    by (auto simp: separated_between)
  have FS: "S \<subseteq> ?F" "closedin X S" "closedin X (?F - S)"
  proof -
    show "S \<subseteq> ?F"
      using closedin_subset[OF S(1)] by auto
    show "closedin X S"
      by (rule closedin_trans_full[OF S(1) F])
    have TF: "topspace ?T = ?F" by auto
    have "closedin ?T (topspace ?T - S)"
      using openin_closedin_eq[of ?T S] S(2) by blast
    then have "closedin ?T (?F - S)" using TF by simp
    then show "closedin X (?F - S)"
      by (rule closedin_trans_full[OF _ F])
  qed
  have "normal_space X"
    using X compact_Hausdorff_or_regular_imp_normal_space by blast
  moreover have "closedin X ((?F - S) \<union> A)" "disjnt S ((?F - S) \<union> A)"
    using FS S A by (auto simp: disjnt_iff)
  ultimately obtain U V where UV: "openin X U" "openin X V"
    "S \<subseteq> U" "(?F - S) \<union> A \<subseteq> V" "disjnt U V"
    using FS(2) unfolding normal_space_def by meson
  have "?F \<subseteq> U \<union> V"
    using UV by blast
  then obtain N where N: "openin Y N" "f x \<in> N"
    "{z \<in> topspace X. f z \<in> N} \<subseteq> U \<union> V"
    using closed_map_fibre_neighbourhood[of X Y f]
      continuous_imp_closed_map[OF f X(1) Y] UV fx by blast
  let ?W = "U \<inter> {z \<in> topspace X. f z \<in> N}"
  have W: "openin X ?W" "x \<in> ?W" "disjnt ?W A"
    using UV N f x S fibre_component_self[OF x, of f]
      openin_continuous_map_preimage[OF f N(1)] by (auto simp: disjnt_iff)
  have sat: "fibre_component X f z \<subseteq> ?W" if "z \<in> ?W" for z
  proof -
    have Nsub: "fibre_component X f z \<subseteq> {t \<in> topspace X. f t \<in> N}"
      using fibre_component_subset[of X f z] that by auto
    have sub: "fibre_component X f z \<subseteq> U \<union> V"
      by (rule subset_trans[OF Nsub N(3)])
    have "fibre_component X f z \<subseteq> U \<or> fibre_component X f z \<subseteq> V"
      using connectedinD[OF fibre_component_connected[of X f z] UV(1,2) sub] UV sub
      by (auto simp: disjnt_def)
    then have "fibre_component X f z \<subseteq> U"
      using that fibre_component_self[of z X f] UV
      by (auto simp: disjnt_iff)
    then show ?thesis
      using fibre_component_subset[of X f z] that by auto
  qed
  show thesis
    using that W sat by blast
qed

theorem component_quotient_closed:
  assumes "compact_space X" "Hausdorff_space X"
    "continuous_map X Y f" "Hausdorff_space Y"
  shows "closed_map X (component_quotient X f) (fibre_component X f)"
proof (unfold closed_map_def, intro allI impI)
  fix A assume A: "closedin X A"
  let ?q = "fibre_component X f"
  let ?Q = "component_quotient X f"
  let ?B = "{x \<in> topspace X. ?q x \<in> ?q ` A}"
  have "openin X (topspace X - ?B)"
  proof (rule openin_subopen[THEN iffD2], intro ballI)
    fix x assume x: "x \<in> topspace X - ?B"
    have "disjnt (?q x) A"
    proof (unfold disjnt_iff, intro allI notI)
      fix z assume "z \<in> ?q x \<and> z \<in> A"
      then have z: "z \<in> ?q x" "z \<in> A" by auto
      have "?q z = ?q x" by (rule fibre_component_eq[OF z(1)])
      then have "?q x \<in> ?q ` A" using z(2) by auto
      then show False using x by auto
    qed
    then obtain W where W: "openin X W" "x \<in> W" "disjnt W A"
      and sat: "\<And>z. z \<in> W \<Longrightarrow> ?q z \<subseteq> W"
      using fibre_component_avoiding_neighbourhood[OF assms A] x by blast
    have "W \<subseteq> topspace X - ?B"
    proof (rule subsetI)
      fix z assume z: "z \<in> W"
      have zX: "z \<in> topspace X" using openin_subset[OF W(1)] z by blast
      have "?q z \<notin> ?q ` A"
      proof
        assume "?q z \<in> ?q ` A"
        then obtain a where a: "a \<in> A" "?q a = ?q z" by blast
        have "a \<in> topspace X" using a(1) closedin_subset[OF A] by blast
        then have "a \<in> ?q a" by (rule fibre_component_self)
        then have "a \<in> W" using a(2) sat[OF z] by blast
        then show False using a(1) W(3) by (auto simp: disjnt_iff)
      qed
      then show "z \<in> topspace X - ?B" using zX by auto
    qed
    then show "\<exists>T. openin X T \<and> x \<in> T \<and> T \<subseteq> topspace X - ?B"
      using W by blast
  qed
  then have "closedin X ?B"
    unfolding closedin_def by auto
  have imsub: "?q ` A \<subseteq> topspace ?Q"
    using closedin_subset[OF A] by (auto simp: component_quotient_topspace)
  have "closedin X ?B \<longleftrightarrow> closedin ?Q (?q ` A)"
    using component_quotient_map[of X f] imsub
    unfolding quotient_map_closedin by blast
  then show "closedin ?Q (?q ` A)" using \<open>closedin X ?B\<close> by blast
qed

theorem component_quotient_compact_Hausdorff:
  assumes "compact_space X" "Hausdorff_space X"
    "continuous_map X Y f" "Hausdorff_space Y"
  shows "compact_space (component_quotient X f)"
    "Hausdorff_space (component_quotient X f)"
proof -
  have q: "continuous_map X (component_quotient X f) (fibre_component X f)"
    by (rule quotient_imp_continuous_map[OF component_quotient_map])
  have "compactin X (topspace X)"
    using assms(1) by (simp add: compact_space_def)
  then have "compactin (component_quotient X f) (fibre_component X f ` topspace X)"
    by (rule image_compactin[OF _ q])
  then show "compact_space (component_quotient X f)"
    by (simp add: compact_space_def component_quotient_topspace)
  have normal: "normal_space X"
    using assms compact_Hausdorff_or_regular_imp_normal_space by blast
  have "normal_space (component_quotient X f) \<and> Hausdorff_space (component_quotient X f)"
    by (rule normal_Hausdorff_space_closed_continuous_map_image[OF normal assms(2)
      component_quotient_closed[OF assms] q]) (simp add: component_quotient_topspace)
  then show "Hausdorff_space (component_quotient X f)" by blast
qed

lemmas component_quotient_compact = component_quotient_compact_Hausdorff(1)
lemmas component_quotient_Hausdorff = component_quotient_compact_Hausdorff(2)

subsection \<open>Lightness and the factorization\<close>

lemma component_quotient_light:
  assumes X: "compact_space X" "Hausdorff_space X"
    and f: "continuous_map X Y f" and Y: "Hausdorff_space Y"
    and l: "continuous_map (component_quotient X f) Y l"
    and eq: "\<And>x. x \<in> topspace X \<Longrightarrow> l (fibre_component X f x) = f x"
  shows "light_map (component_quotient X f) Y l"
proof -
  let ?Q = "component_quotient X f"
  let ?q = "fibre_component X f"
  have q: "continuous_map X ?Q ?q" "closed_map X ?Q ?q"
    using quotient_imp_continuous_map[OF component_quotient_map[of X f]]
      component_quotient_closed[OF X f Y] by blast+
  have pre: "connectedin X {x \<in> topspace X. ?q x \<in> C}"
    if "connectedin ?Q C" for C
    using monotone_closed_map[OF q component_quotient_topspace[of X f, symmetric]]
      component_quotient_monotone[of X f] that by blast
  show ?thesis
    unfolding light_map_def
  proof (intro conjI allI impI ballI)
    show "l ` topspace ?Q \<subseteq> topspace Y"
      by (rule continuous_map_image_subset_topspace[OF l])
  next
    fix y C a b
    assume C: "connectedin ?Q C" "C \<subseteq> {A \<in> topspace ?Q. l A = y}"
      and ab: "a \<in> C" "b \<in> C"
    obtain x where xx: "x \<in> topspace X" "?q x = a"
      using C(2) ab(1) by (auto simp: component_quotient_topspace)
    obtain z where zz: "z \<in> topspace X" "?q z = b"
      using C(2) ab(2) by (auto simp: component_quotient_topspace)
    have xz: "x \<in> topspace X" "z \<in> topspace X" "?q x = a" "?q z = b"
      using xx zz by auto
    let ?D = "{t \<in> topspace X. ?q t \<in> C}"
    have fx: "f x = y" using eq[OF xx(1)] xx(2) ab(1) C(2) by auto
    have fc: "f t = y" if "t \<in> ?D" for t
      using eq[of t] that C(2) by auto
    have csub: "?D \<subseteq> {t \<in> topspace X. f t = f x}"
    proof (rule subsetI)
      fix t assume t: "t \<in> ?D"
      have "f t = y" by (rule fc[OF t])
      then show "t \<in> {t \<in> topspace X. f t = f x}" using fx t by auto
    qed
    have cD: "connectedin (subtopology X {t \<in> topspace X. f t = f x}) ?D"
      using pre[OF C(1)] csub by (simp add: connectedin_subtopology)
    have xd: "x \<in> ?D" "z \<in> ?D"
      using xz ab by auto
    have "?D \<subseteq> ?q x"
      using connected_component_of_maximal[OF cD xd(1)]
      by (simp only: fibre_component_def)
    then have "z \<in> ?q x" using xd(2) by blast
    then have "?q z = ?q x" by (rule fibre_component_eq)
    then show "a = b" using xz by auto
  qed
qed

text_raw \<open>\ProofNeedspace{17\baselineskip}\<close>
theorem monotone_light_factorization:
  assumes "compact_space X" "Hausdorff_space X"
    "continuous_map X Y f" "Hausdorff_space Y"
  obtains l where
    "compact_space (component_quotient X f)"
    "Hausdorff_space (component_quotient X f)"
    "quotient_map X (component_quotient X f) (fibre_component X f)"
    "monotone_map X (component_quotient X f) (fibre_component X f)"
    "continuous_map (component_quotient X f) Y l"
    "light_map (component_quotient X f) Y l"
    "l ` topspace (component_quotient X f) = f ` topspace X"
    "\<And>x. x \<in> topspace X \<Longrightarrow> l (fibre_component X f x) = f x"
proof -
  have eq: "f x = f z" if "x \<in> topspace X" "z \<in> topspace X"
    "fibre_component X f x = fibre_component X f z" for x z
    using fibre_component_self[OF that(1), of f]
      fibre_component_subset[of X f z] that by auto
  obtain l where l: "continuous_map (component_quotient X f) Y l"
    "l ` topspace (component_quotient X f) = f ` topspace X"
    "\<And>x. x \<in> topspace X \<Longrightarrow> l (fibre_component X f x) = f x"
    using quotient_map_lift_exists[OF component_quotient_map assms(3) eq] by blast
  show thesis
    using that component_quotient_compact_Hausdorff[OF assms]
      component_quotient_map[of X f] component_quotient_monotone[of X f] l
      component_quotient_light[OF assms l(1,3)] by blast
qed

subsection \<open>Uniqueness\<close>

text \<open>In an arbitrary factorization, connectedness and lightness force its
first-map fibres to coincide with the components used in the construction.\<close>

lemma monotone_light_fibres:
  assumes p: "continuous_map X Z p" "monotone_map X Z p"
    and k: "light_map Z Y k"
    and eq: "\<And>x. x \<in> topspace X \<Longrightarrow> k (p x) = f x"
    and x: "x \<in> topspace X"
  shows "{z \<in> topspace X. p z = p x} = fibre_component X f x"
proof -
  let ?D = "{z \<in> topspace X. p z = p x}"
  let ?F = "{z \<in> topspace X. f z = f x}"
  let ?C = "fibre_component X f x"
  have D: "connectedin X ?D" "?D \<subseteq> ?F" "x \<in> ?D"
  proof -
    show "connectedin X ?D" using p(2) unfolding monotone_map by auto
    show "?D \<subseteq> ?F"
    proof (rule subsetI)
      fix z assume z: "z \<in> ?D"
      show "z \<in> ?F" using eq[of z] eq[OF x] z by auto
    qed
    show "x \<in> ?D" using x by auto
  qed
  have cD: "connectedin (subtopology X ?F) ?D"
    using D by (simp add: connectedin_subtopology)
  have DC: "?D \<subseteq> ?C"
    unfolding fibre_component_def
    by (rule connected_component_of_maximal[OF cD D(3)])
  have pc: "connectedin Z (p ` ?C)"
    using connectedin_continuous_map_image[OF p(1) fibre_component_connected] .
  have sub: "p ` ?C \<subseteq> {z \<in> topspace Z. k z = f x}"
    using continuous_map_image_subset_topspace[OF p(1)]
      eq fibre_component_subset[of X f x] by auto
  have "p z = p x" if "z \<in> ?C" for z
    using k pc sub that fibre_component_self[OF x, of f]
    unfolding light_map_def by blast
  then have "?C \<subseteq> ?D"
    using fibre_component_subset[of X f x] by blast
  with DC show ?thesis by blast
qed

theorem monotone_light_unique:
  assumes X: "compact_space X" "Hausdorff_space X"
    and f: "continuous_map X Y f" and Y: "Hausdorff_space Y"
    and l: "\<And>x. x \<in> topspace X \<Longrightarrow> l (fibre_component X f x) = f x"
    and Z: "Hausdorff_space Z"
    and p: "continuous_map X Z p" "monotone_map X Z p"
      "p ` topspace X = topspace Z"
    and k: "continuous_map Z Y k" "light_map Z Y k"
    and eq: "\<And>x. x \<in> topspace X \<Longrightarrow> k (p x) = f x"
  obtains h where
    "homeomorphic_map (component_quotient X f) Z h"
    "\<And>x. x \<in> topspace X \<Longrightarrow> h (fibre_component X f x) = p x"
    "\<And>A. A \<in> topspace (component_quotient X f) \<Longrightarrow> k (h A) = l A"
    "\<And>h'. (\<And>x. x \<in> topspace X \<Longrightarrow> h' (fibre_component X f x) = p x)
      \<Longrightarrow> \<forall>A\<in>topspace (component_quotient X f). h' A = h A"
proof -
  let ?Q = "component_quotient X f"
  let ?q = "fibre_component X f"
  have fibres: "?q x = ?q z \<longleftrightarrow> p x = p z"
    if "x \<in> topspace X" "z \<in> topspace X" for x z
  proof -
    have pf: "{t \<in> topspace X. p t = p x} = ?q x"
      by (rule monotone_light_fibres[OF p(1,2) k(2) eq that(1)])
    have zs: "z \<in> ?q z" by (rule fibre_component_self[OF that(2)])
    show ?thesis
    proof
      assume "?q x = ?q z"
      then have "z \<in> ?q x" using zs by simp
      then have "z \<in> {t \<in> topspace X. p t = p x}"
        by (simp only: pf)
      then show "p x = p z" by auto
    next
      assume "p x = p z"
      then have "z \<in> {t \<in> topspace X. p t = p x}" using that(2) by auto
      then have "z \<in> ?q x" by (simp only: pf)
      then have "?q z = ?q x" by (rule fibre_component_eq)
      then show "?q x = ?q z" by simp
    qed
  qed
  have respects: "p x = p z"
    if "x \<in> topspace X" "z \<in> topspace X" "?q x = ?q z" for x z
    using fibres[OF that(1,2)] that(3) by simp
  obtain h where h: "continuous_map ?Q Z h" "h ` topspace ?Q = p ` topspace X"
    "\<And>x. x \<in> topspace X \<Longrightarrow> h (?q x) = p x"
    using quotient_map_lift_exists[OF component_quotient_map[of X f] p(1) respects] by blast
  have inj: "inj_on h (topspace ?Q)"
  proof (rule inj_onI)
    fix A B assume AB: "A \<in> topspace ?Q" "B \<in> topspace ?Q" "h A = h B"
    obtain x where x: "x \<in> topspace X" "?q x = A"
      using AB(1) by (auto simp: component_quotient_topspace)
    obtain z where z: "z \<in> topspace X" "?q z = B"
      using AB(2) by (auto simp: component_quotient_topspace)
    have "p x = p z" using h(3)[OF x(1)] h(3)[OF z(1)] x(2) z(2) AB(3) by auto
    then have "?q x = ?q z" using fibres[OF x(1) z(1)] by simp
    then show "A = B" using x(2) z(2) by simp
  qed
  have homeo: "homeomorphic_map ?Q Z h"
    using continuous_imp_homeomorphic_map[OF h(1)
      component_quotient_compact_Hausdorff(1)[OF X f Y] Z] h(2) p(3) inj by blast
  have commute: "k (h A) = l A" if A: "A \<in> topspace ?Q" for A
  proof -
    obtain x where x: "x \<in> topspace X" "?q x = A"
      using A by (auto simp: component_quotient_topspace)
    show ?thesis using h(3)[OF x(1)] l[OF x(1)] eq[OF x(1)] x(2) by auto
  qed
  have unique: "\<forall>A\<in>topspace ?Q. h' A = h A"
    if u: "\<And>x. x \<in> topspace X \<Longrightarrow> h' (?q x) = p x" for h'
  proof (intro ballI)
    fix A assume "A \<in> topspace ?Q"
    then obtain x where x: "x \<in> topspace X" "?q x = A"
      by (auto simp: component_quotient_topspace)
    show "h' A = h A" using h(3)[OF x(1)] u[OF x(1)] x(2) by auto
  qed
  show thesis using that homeo h(3) commute unique by blast
qed

end
