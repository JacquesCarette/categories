{-# OPTIONS --universe-polymorphism #-}
module Categories.Square where

open import Level
open import Function renaming (id to idᶠ; _∘_ to _©_)

open import Categories.Support.PropositionalEquality

open import Categories.Category
import Categories.Morphisms as Mor

open import Relation.Binary hiding (_⇒_)

module GlueSquares {o a} (C : Category o a) where
  private module C = Category C
  open C
  open Mor C

  module Pulls {X Y Z} {a : Y ⇒ Z} {b : X ⇒ Y} {c : X ⇒ Z} (ab≡c : a ∘ b ≡ c) where
    .pullʳ : ∀ {W} {f : Z ⇒ W} → (f ∘ a) ∘ b ≡ f ∘ c
    pullʳ {f = f} =
      begin
        (f ∘ a) ∘ b
      ↓⟨ assoc ⟩
        f ∘ (a ∘ b)
      ↓⟨ ∘-resp-≡ʳ ab≡c ⟩
        f ∘ c
      ∎
      where open HomReasoning

    .pullˡ : ∀ {W} {f : W ⇒ X} → a ∘ (b ∘ f) ≡ c ∘ f
    pullˡ {f = f} =
      begin
        a ∘ (b ∘ f)
      ↑⟨ assoc ⟩
        (a ∘ b) ∘ f
      ↓⟨ ∘-resp-≡ˡ ab≡c ⟩
        c ∘ f
      ∎
      where open HomReasoning

  open Pulls public

  module Pushes {X Y Z} {a : Y ⇒ Z} {b : X ⇒ Y} {c : X ⇒ Z} (c≡ab : c ≡ a ∘ b) where
    .pushʳ : ∀ {W} {f : Z ⇒ W} → f ∘ c ≡ (f ∘ a) ∘ b
    pushʳ {f = f} =
      begin
        f ∘ c
      ↓⟨ ∘-resp-≡ʳ c≡ab ⟩
        f ∘ (a ∘ b)
      ↑⟨ assoc ⟩
        (f ∘ a) ∘ b
      ∎
      where open HomReasoning

    .pushˡ : ∀ {W} {f : W ⇒ X} → c ∘ f ≡ a ∘ (b ∘ f)
    pushˡ {f = f} =
      begin
        c ∘ f
      ↓⟨ ∘-resp-≡ˡ c≡ab ⟩
        (a ∘ b) ∘ f
      ↓⟨ assoc ⟩
        a ∘ (b ∘ f)
      ∎
      where open HomReasoning

  open Pushes public

  module IntroElim {X} {a : X ⇒ X} (a≡id : a ≡ id) where
    .elimʳ : ∀ {W} {f : X ⇒ W} → (f ∘ a) ≡ f
    elimʳ {f = f} =
      begin
        f ∘ a
      ↓⟨ ∘-resp-≡ʳ a≡id ⟩
        f ∘ id
      ↓⟨ identityʳ ⟩
        f
      ∎
      where
      open HomReasoning

    .introʳ : ∀ {W} {f : X ⇒ W} → f ≡ f ∘ a
    introʳ = Equiv.sym elimʳ

    .elimˡ : ∀ {W} {f : W ⇒ X} → (a ∘ f) ≡ f
    elimˡ {f = f} =
      begin
        a ∘ f
      ↓⟨ ∘-resp-≡ˡ a≡id ⟩
        id ∘ f
      ↓⟨ identityˡ ⟩
        f
      ∎
      where
      open HomReasoning

    .introˡ : ∀ {W} {f : W ⇒ X} → f ≡ a ∘ f
    introˡ = Equiv.sym elimˡ

  open IntroElim public

  module Extends {X Y Z W} {f : X ⇒ Y} {g : X ⇒ Z} {h : Y ⇒ W} {i : Z ⇒ W} (s : CommutativeSquare f g h i) where
    .extendˡ : ∀ {A} {a : W ⇒ A} → CommutativeSquare f g (a ∘ h) (a ∘ i)
    extendˡ {a = a} =
      begin
        (a ∘ h) ∘ f
      ↓⟨ pullʳ s ⟩
        a ∘ i ∘ g
      ↑⟨ assoc ⟩
        (a ∘ i) ∘ g
      ∎
      where
      open HomReasoning

    .extendʳ : ∀ {A} {a : A ⇒ X} → CommutativeSquare (f ∘ a) (g ∘ a) h i
    extendʳ {a = a} =
      begin
        h ∘ (f ∘ a)
      ↓⟨ pullˡ s ⟩
        (i ∘ g) ∘ a
      ↓⟨ assoc ⟩
        i ∘ (g ∘ a)
      ∎
      where
      open HomReasoning

    .extend² : ∀ {A B} {a : W ⇒ A} {b : B ⇒ X} → CommutativeSquare (f ∘ b) (g ∘ b) (a ∘ h) (a ∘ i)
    extend² {a = a} {b} =
      begin
        (a ∘ h) ∘ (f ∘ b)
      ↓⟨ pullʳ extendʳ ⟩
        a ∘ (i ∘ (g ∘ b))
      ↑⟨ assoc ⟩
        (a ∘ i) ∘ (g ∘ b)
      ∎
      where
      open HomReasoning

  open Extends public

  -- essentially composition in the arrow category
  .glue : {X Y Y′ Z Z′ W : Obj} {a : Z ⇒ W} {a′ : Y′ ⇒ Z′} {b : Y ⇒ Z} {b′ : X ⇒ Y′} {c : X ⇒ Y} {c′ : Y′ ⇒ Z} {c″ : Z′ ⇒ W} → CommutativeSquare c′ a′ a c″ → CommutativeSquare c b′ b c′ → CommutativeSquare c (a′ ∘ b′) (a ∘ b) c″
  glue {a = a} {a′} {b} {b′} {c} {c′} {c″} sq-a sq-b = 
    begin
      (a ∘ b) ∘ c
    ↓⟨ pullʳ sq-b ⟩
      a ∘ (c′ ∘ b′)
    ↓⟨ pullˡ sq-a ⟩
      (c″ ∘ a′) ∘ b′
    ↓⟨ assoc ⟩
      c″ ∘ (a′ ∘ b′)
    ∎
    where
    open HomReasoning

  .glue◃◽ : {X Y Y′ Z W : Obj} {a : Z ⇒ W} {b : Y ⇒ Z} {b′ : X ⇒ Y′} {c : X ⇒ Y} {c′ : Y′ ⇒ Z} {c″ : Y′ ⇒ W} → a ∘ c′ ≡ c″ → CommutativeSquare c b′ b c′ → CommutativeSquare c b′ (a ∘ b) c″
  glue◃◽ {a = a} {b} {b′} {c} {c′} {c″} tri-a sq-b =
    begin
      (a ∘ b) ∘ c
    ↓⟨ pullʳ sq-b ⟩
      a ∘ (c′ ∘ b′)
    ↓⟨ pullˡ tri-a ⟩
      c″ ∘ b′
    ∎
    where
    open HomReasoning

  -- essentially composition in the over category
  .glueTrianglesʳ : ∀ {X X′ X″ Y} {a : X ⇒ Y} {b : X′ ⇒ X} {a′ : X′ ⇒ Y} {b′ : X″ ⇒ X′} {a″ : X″ ⇒ Y} 
    → a ∘ b ≡ a′ → a′ ∘ b′ ≡ a″ → a ∘ (b ∘ b′) ≡ a″
  glueTrianglesʳ {a = a} {b} {a′} {b′} {a″} a∘b≡a′ a′∘b′≡a″ =
    begin
      a ∘ (b ∘ b′)
    ↓⟨ pullˡ a∘b≡a′ ⟩
      a′ ∘ b′
    ↓⟨ a′∘b′≡a″ ⟩
      a″
    ∎
    where open HomReasoning

  -- essentially composition in the under category
  .glueTrianglesˡ : ∀ {X Y Y′ Y″} {b : X ⇒ Y} {a : Y ⇒ Y′} {b′ : X ⇒ Y′} {a′ : Y′ ⇒ Y″} {b″ : X ⇒ Y″} → a′ ∘ b′ ≡ b″ → a ∘ b ≡ b′ → (a′ ∘ a) ∘ b ≡ b″
  glueTrianglesˡ {b = b} {a} {b′} {a′} {b″} a′∘b′≡b″ a∘b≡b′ =
    begin
      (a′ ∘ a) ∘ b
    ↓⟨ pullʳ a∘b≡b′ ⟩
      a′ ∘ b′
    ↓⟨ a′∘b′≡b″ ⟩
      b″
    ∎
    where open HomReasoning

  module Cancellers {Y Y′ : Obj} {h : Y′ ⇒ Y} {i : Y ⇒ Y′} (inv : h ∘ i ≡ id) where

    .cancelRight : ∀ {Z} {f : Y ⇒ Z} → (f ∘ h) ∘ i ≡ f
    cancelRight {f = f} =
      begin
        (f ∘ h) ∘ i
      ↓⟨ pullʳ inv ⟩
        f ∘ id
      ↓⟨ identityʳ ⟩
        f
      ∎
      where open HomReasoning

    .cancelLeft : ∀ {X} {f : X ⇒ Y} → h ∘ (i ∘ f) ≡ f
    cancelLeft {f = f} =
      begin
        h ∘ (i ∘ f)
      ↓⟨ pullˡ inv ⟩
        id ∘ f
      ↓⟨ identityˡ ⟩
        f
      ∎
      where open HomReasoning

    .cancelInner : ∀ {X Z} {f : Y ⇒ Z} {g : X ⇒ Y} → (f ∘ h) ∘ (i ∘ g) ≡ f ∘ g
    cancelInner {f = f} {g} =
      begin
        (f ∘ h) ∘ (i ∘ g)
      ↓⟨ pullˡ cancelRight ⟩
        f ∘ g
      ∎
      where open HomReasoning
  
  open Cancellers public

  module Switch {X Y} (i : X ≅ Y) where
    open _≅_ i

    .switch-fgˡ : ∀ {W} {h : W ⇒ X} {k : W ⇒ Y} → (f ∘ h ≡ k) → (h ≡ g ∘ k)
    switch-fgˡ {h = h} {k} pf =
      begin
        h
      ↑⟨ cancelLeft isoˡ ⟩
        g ∘ (f ∘ h)
      ↓⟨ ∘-resp-≡ʳ pf ⟩
        g ∘ k
      ∎
      where open HomReasoning

    .switch-gfˡ : ∀ {W} {h : W ⇒ Y} {k : W ⇒ X} → (g ∘ h ≡ k) → (h ≡ f ∘ k)
    switch-gfˡ {h = h} {k} pf =
      begin
        h
      ↑⟨ cancelLeft isoʳ ⟩
        f ∘ (g ∘ h)
      ↓⟨ ∘-resp-≡ʳ pf ⟩
        f ∘ k
      ∎
      where open HomReasoning

    .switch-fgʳ : ∀ {W} {h : Y ⇒ W} {k : X ⇒ W} → (h ∘ f ≡ k) → (h ≡ k ∘ g)
    switch-fgʳ {h = h} {k} pf =
      begin
        h
      ↑⟨ cancelRight isoʳ ⟩
        (h ∘ f) ∘ g
      ↓⟨ ∘-resp-≡ˡ pf ⟩
        k ∘ g
      ∎
      where open HomReasoning

    .switch-gfʳ : ∀ {W} {h : X ⇒ W} {k : Y ⇒ W} → (h ∘ g ≡ k) → (h ≡ k ∘ f)
    switch-gfʳ {h = h} {k} pf =
      begin
        h
      ↑⟨ cancelRight isoˡ ⟩
        (h ∘ g) ∘ f
      ↓⟨ ∘-resp-≡ˡ pf ⟩
        k ∘ f
      ∎
      where open HomReasoning

  open Switch public

module AUReasoning {o a} (C : Category o a) where
  private module C = Category C
  open C
  open Equiv

  infix  4 _IsRelatedTo_
  infix  2 _∎
  infixr 2 _≈⟨_⟩_
  infixr 2 _↓⟨_⟩_
  infixr 2 _↑⟨_⟩_
  infixr 2 _↓≡⟨_⟩_
  infixr 2 _↑≡⟨_⟩_
  infixr 2 _↕_
  infix  1 begin_
  infixr 8 _∙_

  data Climb : Rel Obj (o ⊔ a) where
    ID : ∀ {X} → Climb X X
    leaf : ∀ {X Y} → (X ⇒ Y) → Climb X Y
    _branch_ : ∀ {X Y Z} (l : Climb Y Z) (r : Climb X Y) → Climb X Z

  interp : ∀ {p} (P : Rel Obj p)
           (f-id : ∀ {X} → P X X)
           (f-leaf : ∀ {X Y} → X ⇒ Y → P X Y)
           (f-branch : ∀ {X Y Z} → P Y Z → P X Y → P X Z)
         → ∀ {X Y} → Climb X Y → P X Y
  interp P f-id f-leaf f-branch ID = f-id
  interp P f-id f-leaf f-branch (leaf y) = f-leaf y
  interp P f-id f-leaf f-branch (l branch r) = f-branch
    (interp P f-id f-leaf f-branch l)
    (interp P f-id f-leaf f-branch r)

  eval : ∀ {X Y} → Climb X Y → X ⇒ Y
  eval = interp _⇒_ id idᶠ _∘_

  record Yon (X Y : Obj) : Set (o ⊔ a) where
    field
      arr : X ⇒ Y
      fun : ∀ {W} (f : W ⇒ X) → (W ⇒ Y)
      .ok : ∀ {W} (f : W ⇒ X) → fun f ≡ arr ∘ f

    norm : X ⇒ Y
    norm = fun id

    .norm≡arr : norm ≡ arr
    norm≡arr = trans (ok id) identityʳ

    .ok-ext : (λ {W} → fun {W}) ≣ (_∘_ arr)
    ok-ext = ≣-extʰ (≣-ext ok)

  Yon-id : ∀ {X} → Yon X X
  Yon-id = record
    { arr = id
    ; fun = idᶠ
    ; ok = λ _ → sym identityˡ
    }

  Yon-inject : ∀ {X Y} → (X ⇒ Y) → Yon X Y
  Yon-inject f = record { arr = f; fun = _∘_ f; ok = λ _ → refl }

  -- XXX can compose be done with less ext?
  Yon-compose : ∀ {X Y Z} → (Yon Y Z) → (Yon X Y) → (Yon X Z)
  Yon-compose g f = record
    { arr = g.fun f.arr
    ; fun = g.fun © f.fun
    ; ok = λ h → trans (≣-cong g.fun (f.ok h)) (trans (g.ok (f.arr ∘ h)) (sym (trans (∘-resp-≡ˡ (g.ok f.arr)) assoc)))
    }
    where
    module g = Yon g
    module f = Yon f

  yeval : ∀ {X Y} → Climb X Y → Yon X Y
  yeval = interp Yon Yon-id Yon-inject Yon-compose

  .yarr : ∀ {X Y} → (t : Climb X Y) → Yon.arr (yeval t) ≣ eval t
  yarr ID = ≣-refl
  yarr (leaf y) = ≣-refl
  yarr (t branch t1) = ≣-trans (Yon.ok (yeval t) (Yon.arr (yeval t1))) (∘-resp-≡ (yarr t) (yarr t1))

  .ynormal : ∀ {X Y} → (y₁ y₂ : Yon X Y) → Yon.arr y₁ ≡ Yon.arr y₂ → y₁ ≣ y₂
  ynormal {X} {Y} y₁ y₂ pf = lemma pf
      (≣-trans ok-ext (≣-trans (≣-cong (λ f {W} → _∘_ {W} f) pf) (≣-sym y₂.ok-ext)))
    where
    open Yon y₁
    module y₂ = Yon y₂
    lemma : ∀ {arr′ : X ⇒ Y} {fun′ : ∀ {W} → (W ⇒ X) → (W ⇒ Y)}
            → (eq₁ : arr ≡ arr′) (eq₂ : (λ {W} → fun) ≣ fun′)
            → y₁ ≣ record { arr = arr′; fun = fun′
                          ; ok = λ {W} f → ≣-subst₂ (λ arr″ f″ → f″ ≣ arr″ ∘ f) eq₁ (≣-app (≣-appʰ eq₂ {W}) f) (ok f) }
    lemma ≣-refl ≣-refl = ≣-refl

  .Yon-assoc : ∀ {X Y Z W} (f : Yon Z W) (g : Yon Y Z) (h : Yon X Y) → Yon-compose f (Yon-compose g h) ≣ Yon-compose (Yon-compose f g) h
  Yon-assoc f g h = ≣-refl

  .Yon-identityˡ : ∀ {X Y} (f : Yon X Y) → Yon-compose Yon-id f ≣ f
  Yon-identityˡ f = ≣-refl

  .Yon-identityʳ : ∀ {X Y} (f : Yon X Y) → Yon-compose f Yon-id ≣ f
  Yon-identityʳ f = ynormal (Yon-compose f Yon-id) f (Yon.norm≡arr f)

  record Eda (X Y : Obj) : Set (o ⊔ a) where
    field
      yon : Yon X Y
      fun : ∀ {Z} (f : Yon Y Z) → Yon X Z
      .ok : ∀ {Z} (f : Yon Y Z) → fun f ≣ Yon-compose f yon

    norm : Yon X Y
    norm = fun Yon-id

    .ok-ext : (λ {Z} → fun {Z}) ≣ (flip Yon-compose yon)
    ok-ext = ≣-extʰ (≣-ext ok)

    open Yon yon public using (arr)

  Eda-id : ∀ {X} → Eda X X
  Eda-id = record
    { yon = Yon-id
    ; fun = idᶠ
    ; ok = ≣-sym © Yon-identityʳ
    }

  Eda-inject : ∀ {X Y} → Yon X Y → Eda X Y
  Eda-inject f = record { yon = f; fun = flip Yon-compose f; ok = λ _ → ≣-refl }

  -- XXX can compose be done with less ext?
  Eda-compose : ∀ {X Y Z} → (Eda Y Z) → (Eda X Y) → (Eda X Z)
  Eda-compose g f = record
    { yon = f.fun g.yon
    ; fun = f.fun © g.fun
    ; ok = λ h → ≣-trans (≣-cong f.fun (g.ok h)) (≣-trans (f.ok (Yon-compose h g.yon)) (≣-sym (≣-cong (Yon-compose h) (f.ok g.yon))))
    }
    where
    module g = Eda g
    module f = Eda f

  eeval : ∀ {X Y} → Climb X Y → Eda X Y
  eeval = interp Eda Eda-id (Eda-inject © Yon-inject) Eda-compose

  .eyon : ∀ {X Y} → (t : Climb X Y) → Eda.yon (eeval t) ≣ yeval t
  eyon ID = ≣-refl
  eyon (leaf y) = ≣-refl
  eyon (t branch t1) = ≣-trans (Eda.ok (eeval t1) (Eda.yon (eeval t))) (≣-cong₂ Yon-compose (eyon t) (eyon t1))

  .enormal : ∀ {X Y} → (y₁ y₂ : Eda X Y) → Eda.yon y₁ ≣ Eda.yon y₂ → y₁ ≣ y₂
  enormal {X} {Y} y₁ y₂ pf = lemma pf
      (≣-trans ok-ext (≣-trans (≣-cong (λ f {Z} → flip (Yon-compose {Z = Z}) f) pf) (≣-sym y₂.ok-ext)))
    where
    open Eda y₁
    module y₂ = Eda y₂
    lemma : ∀ {yon′ : Yon X Y} {fun′ : ∀ {Z} → Yon Y Z → Yon X Z}
            → (eq₁ : yon ≣ yon′) (eq₂ : (λ {Z} → fun) ≣ fun′)
            → y₁ ≣ record { yon = yon′; fun = fun′
                          ; ok = λ {Z} f → ≣-subst₂ (λ yon″ f″ → f″ ≣ Yon-compose f yon″) eq₁ (≣-app (≣-appʰ eq₂ {Z}) f) (ok f) }
    lemma ≣-refl ≣-refl = ≣-refl

  .earr : ∀ {X Y} → (t : Climb X Y) → Eda.arr (eeval t) ≣ eval t
  earr t = trans (≣-cong Yon.arr (eyon t)) (yarr t)

  .yynormal : ∀ {X Y} → (y₁ y₂ : Eda X Y) → Eda.arr y₁ ≡ Eda.arr y₂ → y₁ ≣ y₂
  yynormal y₁ y₂ = enormal y₁ y₂ © ynormal (Eda.yon y₁) (Eda.yon y₂)

  .Eda-assoc : ∀ {X Y Z W} (f : Eda Z W) (g : Eda Y Z) (h : Eda X Y) → Eda-compose f (Eda-compose g h) ≣ Eda-compose (Eda-compose f g) h
  Eda-assoc f g h = ≣-refl

  -- .Eda-identityˡ : ∀ {X Y} (f : Eda X Y) → Eda-compose Eda-id f ≣ f
  -- Eda-identityˡ f = {!!}

  .Eda-identityʳ : ∀ {X Y} (f : Eda X Y) → Eda-compose f Eda-id ≣ f
  Eda-identityʳ f = ≣-refl

  yyeval : ∀ {X Y} → (t : Climb X Y) → (X ⇒ Y)
  yyeval = Eda.arr © eeval

  record ClimbBuilder (X Y : Obj) {t} (T : Set t) : Set (o ⊔ a ⊔ t) where
    field build : T → Climb X Y

  leafBuilder : ∀ {X Y} → ClimbBuilder X Y (X ⇒ Y)
  leafBuilder = record { build = leaf }

  idBuilder : ∀ {X Y} → ClimbBuilder X Y (Climb X Y)
  idBuilder = record { build = idᶠ }

  _∙_ : ∀ {X Y Z} {s} {S : Set s} {{Sb : ClimbBuilder Y Z S}} (f : S) {t} {T : Set t} {{Tb : ClimbBuilder X Y T}} (g : T) → Climb X Z
  _∙_ {{Sb}} f {{Tb}} g = ClimbBuilder.build Sb f branch ClimbBuilder.build Tb g

  

  -- yreflect : ∀ {X Y} → (t₁ t₂ : Climb X Y) → (yeval t₁ ≣ yeval t₂) → eval t₁ ≣ eval t₂
  -- yreflect t₁ t₂ pf = ≣-trans (≣-sym (ynorm t₁) (≣-trans (≣-cong (λ y → Yon.fun pf (≣-sym ynorm))

  data _IsRelatedTo_ {X Y} (f g : Climb X Y) : Set a where
    relTo : (f∼g : yyeval f ≡ yyeval g) → f IsRelatedTo g

  .begin_ : ∀ {X Y} {f g : Climb X Y} → f IsRelatedTo g → eval f ≡ eval g
  begin_ {f = f} {g} (relTo f∼g) = trans (sym (earr f)) (trans f∼g (earr g))

  ._↓⟨_⟩_ : ∀ {X Y} (f : Climb X Y) {g h} → (yyeval f ≡ yyeval g) → g IsRelatedTo h → f IsRelatedTo h
  _ ↓⟨ f∼g ⟩ relTo g∼h = relTo (trans f∼g g∼h)

  ._↑⟨_⟩_ : ∀ {X Y} (f : Climb X Y) {g h} → (yyeval g ≡ yyeval f) → g IsRelatedTo h → f IsRelatedTo h
  _ ↑⟨ g∼f ⟩ relTo g∼h = relTo (trans (sym g∼f) g∼h)

  -- the syntax of the ancients, for compatibility
  ._≈⟨_⟩_ : ∀ {X Y} (f : Climb X Y) {g h} → (yyeval f ≡ yyeval g) → g IsRelatedTo h → f IsRelatedTo h
  _ ≈⟨ f∼g ⟩ relTo g∼h = relTo (trans f∼g g∼h)

  ._↓≡⟨_⟩_ : ∀ {X Y} (f : Climb X Y) {g h} → eval f ≡ eval g → g IsRelatedTo h → f IsRelatedTo h
  _↓≡⟨_⟩_ f {g} f∼g (relTo g∼h) = relTo (trans (earr f) (trans f∼g (trans (sym (earr g)) g∼h)))

  ._↑≡⟨_⟩_ : ∀ {X Y} (f : Climb X Y) {g h} → eval g ≡ eval f → g IsRelatedTo h → f IsRelatedTo h
  _↑≡⟨_⟩_ f {g} g∼f (relTo g∼h) = relTo (trans (earr f) (trans (sym g∼f) (trans (sym (earr g)) g∼h)))

  -- XXX i want this to work whenever the Edas are equal -- but that probably
  -- requires Climb to be indexed by yyeval!  oh, for cheap ornamentation.
  ._↕_ : ∀ {X Y} (f : Climb X Y) {h} → f IsRelatedTo h → f IsRelatedTo h
  _ ↕ f∼h = f∼h

  ._∎ : ∀ {X Y} (f : Climb X Y) → f IsRelatedTo f
  _∎ _ = relTo refl
