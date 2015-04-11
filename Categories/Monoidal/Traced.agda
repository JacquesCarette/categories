{-# OPTIONS --universe-polymorphism #-}
module Categories.Monoidal.Traced where

open import Level

open import Data.Product

open import Categories.Category
open import Categories.Power hiding (module C)
open import Categories.Power.NaturalTransformation hiding (module C)
open import Categories.Monoidal
open import Categories.Functor hiding (_∘_; identityʳ; assoc)
open import Categories.Monoidal.Braided
open import Categories.Monoidal.Helpers
open import Categories.Monoidal.Braided.Helpers
open import Categories.Monoidal.Symmetric
open import Categories.NaturalIsomorphism
open import Categories.NaturalTransformation 

record Traced {o ℓ e} {C : Category o ℓ e} {M : Monoidal C} {B : Braided M}
  (S : Symmetric B) : Set (o ⊔ ℓ ⊔ e) where

  private module C = Category C
  open C using (Obj; _∘_)

  private module M = Monoidal M
  open M using (⊗; identityʳ; assoc) renaming (id to 𝟙)

  private module F = Functor ⊗
  open F using () renaming (F₀ to ⊗ₒ)

  private module NIʳ = NaturalIsomorphism identityʳ
  open NaturalTransformation NIʳ.F⇒G renaming (η to ηidr⇒)
  open NaturalTransformation NIʳ.F⇐G renaming (η to ηidr⇐)

  private module NIassoc = NaturalIsomorphism assoc
  open NaturalTransformation NIassoc.F⇒G renaming (η to ηassoc⇒)
  open NaturalTransformation NIassoc.F⇐G renaming (η to ηassoc⇐)

  field
    trace : ∀ {X A B} → C [ ⊗ₒ (A , X)  , ⊗ₒ (B , X) ] → C [ A , B ]

    vanish_id : ∀ {A B f} →
                C [
                    trace {𝟙} {A} {B} f
                  ≡
                    (ηidr⇒ (λ _ → B) ∘ f ∘ ηidr⇐ (λ _ → A))
                  ]
                  
    vanish_⊗ : ∀ {X Y A B f} →
               C [
                    trace {⊗ₒ (X , Y)} {A} {B} f
                  ≡
                    trace {X} {A} {B}
                      (trace {Y} {⊗ₒ (A , X)} {⊗ₒ (B , X)}
                        ((ηassoc⇐ {!!} ∘ f ∘ ηassoc⇒ {!!})))
                 ]

{--
We have:

  f : C [ ⊗ₒ (A , ⊗ₒ (X , Y)) , ⊗ₒ (B , ⊗ₒ (X , Y)) ]

We want:

    C [ ⊗ₒ (⊗ₒ (A , X) , Y) , ⊗ₒ (⊗ₒ (B , X) , Y) ]

We have an ηassoc⇒ that maps between [x⊗y]⊗z and x⊗[y⊗z] 
but it works in (Exp (Fin 3)) 

Need to construct an object in Exp (Fin 3) C that would correspond to
⊗ₒ (⊗ₒ (A , X) , Y)

--}

------------------------------------------------------------------------------

{--
From: http://ncatlab.org/nlab/show/traced+monoidal+category

A symmetric monoidal category (C,⊗,1,b) (where b is the symmetry) is
said to be traced if it is equipped with a natural family of functions

TrXA,B:C(A⊗X,B⊗X)→C(A,B)
satisfying three axioms:

Vanishing: Tr1A,B(f)=f (for all f:A→B) and
TrX⊗YA,B=TrXA,B(TrYA⊗X,B⊗X(f)) (for all f:A⊗X⊗Y→B⊗X⊗Y)

Superposing: TrXC⊗A,C⊗B(idC⊗f)=idC⊗TrXA,B(f) (for all f:A⊗X→B⊗X)

Yanking: TrXX,X(bX,X)=idX
--}
