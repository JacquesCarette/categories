-- Actually, we're cheating (for expediency); this is
-- Symmetric Rig, not just Rig.
module Categories.RigCategory where

open import Level
open import Data.Fin renaming (zero to 0F; suc to sucF)
open import Data.Product using (_,_)

open import Categories.Category
open import Categories.Functor
open import Categories.Monoidal
open import Categories.Monoidal.Braided
open import Categories.Monoidal.Braided.Helpers
open import Categories.Monoidal.Symmetric
open import Categories.Monoidal.Helpers
open import Categories.NaturalIsomorphism
open import Categories.NaturalTransformation using (_∘₀_; _∘₁_; _∘ˡ_; _∘ʳ_; NaturalTransformation) renaming (_≡_ to _≡ⁿ_; id to idⁿ)

-- first round of setting up, just for defining the NaturalIsomorphisms
-- of Rig.  Next one will be for the equalities.
module BimonoidalHelperFunctors {o ℓ e} {C : Category o ℓ e} 
  {M⊎ M× : Monoidal C} (B⊎ : Braided M⊎) (B× : Braided M×) where

  private
    module C = Category C
    module M⊎ = Monoidal M⊎
    module M× = Monoidal M×
    module B⊎ = Braided B⊎
    module B× = Braided B×

  module h⊎ = MonoidalHelperFunctors C M⊎.⊗ M⊎.id
  module h× = MonoidalHelperFunctors C M×.⊗ M×.id
  module b⊎ = BraidedHelperFunctors C M⊎.⊗ M⊎.id
  module b× = BraidedHelperFunctors C M×.⊗ M×.id

  module br⊎ = b⊎.Braiding M⊎.identityˡ M⊎.identityʳ M⊎.assoc B⊎.braid
  module br× = b×.Braiding M×.identityˡ M×.identityʳ M×.assoc B×.braid
  
  import Categories.Power.NaturalTransformation
  private module PowNat = Categories.Power.NaturalTransformation C
  open PowNat hiding (module C)

  -- these could be defined in Helpers, but seem not to be
  x⊗z : Powerendo 3
  x⊗z = select 0 h×.⊗₂ select 2
  
  z⊗x : Powerendo 3
  z⊗x = (select 2) h×.⊗₂ (select 0)

  z⊗y : Powerendo 3
  z⊗y = select 2 h×.⊗₂ select 1

  y⊗z : Powerendo 3
  y⊗z = select 1 h×.⊗₂ select 2
  
  x⊗[y⊕z] : Powerendo 3
  x⊗[y⊕z] = h×.x h×.⊗ (h⊎.x⊗y)

  x⊗[z⊕y] : Powerendo 3
  x⊗[z⊕y] = h×.x h×.⊗ h⊎.y⊗x

  [x⊕y]⊗z : Powerendo 3
  [x⊕y]⊗z = (h⊎.x⊗y) h×.⊗ h×.x

  z⊗[x⊕y] : Powerendo 3
  z⊗[x⊕y] = (select 2) h×.⊗₂ ((select 0) h⊎.⊗₂ (select 1))
  
  [x⊗y]⊕[x⊗z] : Powerendo 3
  [x⊗y]⊕[x⊗z] = (select 0 h×.⊗₂ select 1) h⊎.⊗₂ (select 0 h×.⊗₂ select 2) 

  [x⊗z]⊕[y⊗z] : Powerendo 3
  [x⊗z]⊕[y⊗z] = (select 0 h×.⊗₂ select 2) h⊎.⊗₂ (select 1 h×.⊗₂ select 2)

  [z⊗x]⊕[z⊗y] : Powerendo 3
  [z⊗x]⊕[z⊗y] = z⊗x h⊎.⊗₂ z⊗y

  [x⊗z]⊕[x⊗y] : Powerendo 3
  [x⊗z]⊕[x⊗y] = x⊗z h⊎.⊗₂ (select 0 h×.⊗₂ select 1)
  
  x⊗0 : Powerendo 1
  x⊗0 = h⊎.x h×.⊗ h⊎.id↑

  0⊗x : Powerendo 1
  0⊗x = h⊎.id↑ h×.⊗ h⊎.x

  0↑ : Powerendo 1
  0↑ = widenˡ 1 h⊎.id↑

  module SRig (S⊎ : Symmetric B⊎) (S× : Symmetric B×)
    (distribₗ : NaturalIsomorphism x⊗[y⊕z] [x⊗y]⊕[x⊗z])
    (distribᵣ : NaturalIsomorphism [x⊕y]⊗z [x⊗z]⊕[y⊗z])
    (annₗ : NaturalIsomorphism x⊗0 0↑)
    (annᵣ : NaturalIsomorphism 0⊗x 0↑) where

    open NaturalIsomorphism distribₗ using () renaming (F⇒G to dₗ)
    open NaturalIsomorphism distribᵣ using () renaming (F⇒G to dᵣ)

    dₗ-over : ∀ {n} (F₁ F₂ F₃ : Powerendo n) → NaturalTransformation (F₁ h×.⊗₂ (F₂ h⊎.⊗₂ F₃)) ((F₁ h×.⊗₂ F₂) h⊎.⊗₂ (F₁ h×.⊗₂ F₃))
    dₗ-over F₁ F₂ F₃ = dₗ ∘ʳ plex {3} F₁ F₂ F₃
    
    dᵣ-over : ∀ {n} (F₁ F₂ F₃ : Powerendo n) → NaturalTransformation ((F₁ h⊎.⊗₂ F₂) h×.⊗₂ F₃) ((F₁ h×.⊗₂ F₃) h⊎.⊗₂ (F₂ h×.⊗₂ F₃))
    dᵣ-over F₁ F₂ F₃ = dᵣ ∘ʳ plex {3} F₁ F₂ F₃
    
    Bxz : NaturalTransformation x⊗z z⊗x
    Bxz = br×.B-over (select 0) (select 2)

    Byz : NaturalTransformation y⊗z z⊗y
    Byz = br×.B-over (select 1) (select 2)
  
    Bxz⊕Byz : NaturalTransformation [x⊗z]⊕[y⊗z] [z⊗x]⊕[z⊗y]
    Bxz⊕Byz = Bxz h⊎.⊗ⁿ′ Byz

    B[x⊕y]z : NaturalTransformation [x⊕y]⊗z z⊗[x⊕y]
    B[x⊕y]z = br×.B-over (widenʳ 1 h⊎.x⊗y) (select 2)

    dᵣABC : NaturalTransformation [x⊕y]⊗z [x⊗z]⊕[y⊗z]
    dᵣABC = dᵣ-over (select 0) (select 1) (select 2)

    dₗABC : NaturalTransformation x⊗[y⊕z] [x⊗y]⊕[x⊗z]
    dₗABC = dₗ-over (select 0) (select 1) (select 2)

    dₗACB : NaturalTransformation x⊗[z⊕y] [x⊗z]⊕[x⊗y]
    dₗACB = dₗ-over (select 0) (select 2) (select 1)
    
    dₗCAB : NaturalTransformation z⊗[x⊕y] [z⊗x]⊕[z⊗y]
    dₗCAB = dₗ-over (select 2) (select 0) (select 1)

    1⊗Byz : NaturalTransformation x⊗[y⊕z] x⊗[z⊕y]
    1⊗Byz = reduceN M×.⊗ h×.id₂ (br⊎.B-over (select 0) (select 1))

    B[x⊗y][x⊗z] : NaturalTransformation [x⊗y]⊕[x⊗z] [x⊗z]⊕[x⊗y]
    B[x⊗y][x⊗z] = br⊎.B-over (widenʳ 1 h×.x⊗y) x⊗z
    
record RigCategory {o ℓ e} {C : Category o ℓ e} 
  {M⊎ M× : Monoidal C} {B⊎ : Braided M⊎} (S⊎ : Symmetric B⊎)
   {B× : Braided M×} (S× : Symmetric B×) : Set (o ⊔ ℓ ⊔ e) where

  open BimonoidalHelperFunctors B⊎ B×

  field
    distribₗ : NaturalIsomorphism x⊗[y⊕z] [x⊗y]⊕[x⊗z]
    distribᵣ : NaturalIsomorphism [x⊕y]⊗z [x⊗z]⊕[y⊗z]
    annₗ : NaturalIsomorphism x⊗0 0↑
    annᵣ : NaturalIsomorphism 0⊗x 0↑

  open SRig S⊎ S× distribₗ distribᵣ annₗ annᵣ

  -- need II, IX, X, XV
  -- choose I, IV, VI, XI, XIII, XIX, and (XVI, XVII)
  field
    laplazaI : dₗACB ∘₁ 1⊗Byz ≡ⁿ B[x⊗y][x⊗z] ∘₁ dₗABC
    laplazaII : Bxz⊕Byz ∘₁ dᵣABC ≡ⁿ dₗCAB ∘₁ B[x⊕y]z
  
