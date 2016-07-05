module Nat where

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ

_+_ : ℕ → ℕ → ℕ
zero + m = m
succ n + m = succ (n + m) 

double-plus-unbad : ℕ → ℕ → ℕ → ℕ
double-plus-unbad x y z = (x + y) + z

double-plus-good : ℕ → ℕ → ℕ → ℕ
double-plus-good zero y z = y + z
double-plus-good (succ x) y z = succ (double-plus-good x y z) 

{-

<pre>
                                                                  ─────────────────────────(*) 
                                                                  n : ℕ , m : ℕ ⊢ n + m : ℕ  
                                       ──────────────var      ───────────────────────────────succ
                                      m : ℕ ⊢ m : ℕ            n : ℕ , m : ℕ ⊢ succ (n + m) : ℕ  
─────────────var ─────────────var  ──────────────────────────────────────────────────────────case(†)
n : ℕ ⊢ n : ℕ     m : ℕ ⊢ m : ℕ        n : ℕ , m : ℕ ⊢ λ { zero → m ; succ n → succ (n + m)} n
───────────────────────────────────────────────────────────────────────────────────────────app
        n : ℕ , m : ℕ ⊢ (λ n m → λ { zero → m ; succ n → n + m} n) n m : ℕ 
  ──────────────────────────────────────────────────────────────────────────unfold(*) 
                             n : ℕ , m : ℕ ⊢ n + m : ℕ
</pre>

<pre>

      
────────────────────────(*) ─────────────var  ────────────────────────────────────────────────────(†)
x : ℕ , y : ℕ ⊢ x + y : ℕ     z : ℕ ⊢ z : ℕ     n : ℕ , m : ℕ ⊢ λ { zero → m ; succ n → succ (n + m)} n
───────────────────────────────────────────────────────────────────────────────────────────app
     x : ℕ , y : ℕ , z : ℕ ⊢ (λ n m → λ { zero → m ; succ n → succ (n + m)} n)) (x + y) z : ℕ 
     ──────────────────────────────────────────────────────────────────────────────────unfold
                               x : ℕ , y : ℕ , z : ℕ ⊢ (x + y) + z : ℕ
                           ──────────────────────────────────────unfold
                             x : ℕ , y : ℕ , z : ℕ ⊢ dpu x y z : ℕ

</pre>


<pre>
                                                      ──────────────────────────────────(§)                                                    
                                                     x : ℕ , y : ℕ , z : ℕ ⊢ dpg x y z : ℕ 
                   ───────────────────────(*) ──────────────────────────────────────────────────succ
                   y : ℕ , z ∶ ℕ ⊢ y + z : ℕ   x : ℕ , y : ℕ , z : ℕ ⊢ succ x → succ (dpg x y z) : ℕ 
                     ────────────────────────────────────────────────────────────────────────case                               
───────────────────var   x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → y + z                                        
x,y,z : ℕ ⊢ x,y,z : ℕ                                 ; succ x → succ (dpg x y z)} x : ℕ 
────────────────────────────────────────────────────────────────────────────────────app,lam
  x : ℕ , y : ℕ , z : ℕ ⊢ (λ x y z → λ { zero → y + z
                                         ; succ x → dpg x y z} x) x y z : ℕ
   ──────────────────────────────────────────────────────────────────────unfold (§)
                           x : ℕ , y : ℕ , z : ℕ ⊢ dpg x y z : ℕ
</pre>


<pre>
(λ { zero → M ; succ x → N }) ((λ {zero → P ; succ x' → Q}) R)
↝
((λ {zero → (λ { zero → M ; succ x → N }) P ; succ x' → (λ { zero → M ; succ x → N }) Q}) R)
</pre>



<pre>
 
                                                    ─────────────────────────────────────(§) 
─────────────────────────────────────(†)         n : ℕ , y : ℕ , z : ℕ ⊢ (n + y) + z : ℕ 
n : ℕ , m : ℕ ⊢ λ { zero → m                    ───────────────────────────────────────────succ
                     ; succ n → succ (n + m)} n  n : ℕ , y : ℕ , z : ℕ ⊢ succ ((n + y) + z) : ℕ
───────────────────────────────────────────────────────────────────────────────↝
x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → (λ { zero → z
                                        ; succ n → succ (n + z)} y)
                            ; succ n → succ ((n + y) + z)} x : ℕ 
───────────────────────────────────────────────────────────────────────────────↝
x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → (λ { zero → z
                                        ; succ n → succ (n + z)} y)
                            ; succ n → (λ { zero → z
                                          ; succ n → succ (n + z)} (succ (n + y)))} x : ℕ 
──────────────────────────────────────────────────────────────────────────────↝
x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → z
                            ; succ n → succ (n + z)} (λ { zero → y
                                                         ; succ n → succ (n + y)} x) : ℕ 
───────────────────────────────────────────────────────────────────────────────↝
                x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → z
                                            ; succ n → succ (n + z)} (x + y)) : ℕ 
     ──────────────────────────────────────────────────────────────────────────↝
    x : ℕ , y : ℕ , z : ℕ ⊢ (λ n m → λ { zero → m ; succ n → n + m} n) (x + y) z : ℕ 
  ────────────────────────────────────────────────────────────────────────────unfold(§) 
                               x : ℕ , y : ℕ , z : ℕ ⊢ (x + y) + z : ℕ
                           ──────────────────────────────────────unfold
                             x : ℕ , y : ℕ , z : ℕ ⊢ dpu x y z : ℕ

</pre>

<pre>
                                                    ─────────────────────────────────────(§) 
                                                    x : ℕ , y : ℕ , z : ℕ ⊢ (x + y) + z : ℕ 
─────────────(*)              ──────────────────────────────────────────────────succ
z : ℕ ⊢ z : ℕ                x : ℕ , y : ℕ , z : ℕ ⊢ succ x → succ ((x + y) + z) : ℕ


──────────────────────────────────────────────────────────────────────────
x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → z
                            ; succ n → succ (n + z)} (λ { zero → y
                                                        ; succ n → succ (n + z)} x) : ℕ 
───────────────────────────────────────────────────────────────────────────↝
                x : ℕ , y : ℕ , z : ℕ ⊢ λ { zero → z
                                            ; succ n → succ (n + z)} (x + y)) : ℕ 
     ──────────────────────────────────────────────────────────────────────────↝
    x : ℕ , y : ℕ , z : ℕ ⊢ (λ n m → λ { zero → m ; succ n → n + m} n) (x + y) z : ℕ 
  ────────────────────────────────────────────────────────────────────────────unfold(§) 
                               x : ℕ , y : ℕ , z : ℕ ⊢ (x + y) + z : ℕ
                           ──────────────────────────────────────unfold
                             x : ℕ , y : ℕ , z : ℕ ⊢ dpu x y z : ℕ

</pre> 

-} 
