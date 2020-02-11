(module
  (memory 1)

  (type $i32_T (func (param i32 i32) (result i32)))
  (type $i64_T (func (param i64 i64) (result i32)))
  ;;(type $f32_T (func (param f32 f32) (result i32)))
  ;;(type $f64_T (func (param f64 f64) (result i32)))
  (table funcref
    (elem $i32_t0 $i32_t1 $i64_t0 $i64_t1 $i32_t0 $i32_t1 $i64_t0 $i64_t1)
  )

  (func $i32_t0 (type $i32_T) (i32.const -1))
  (func $i32_t1 (type $i32_T) (i32.const -2))
  (func $i64_t0 (type $i64_T) (i32.const -1))
  (func $i64_t1 (type $i64_T) (i32.const -2))
  ;;(func $f32_t0 (type $f32_T) (i32.const -1))
  ;;(func $f32_t1 (type $f32_T) (i32.const -2))
  ;;(func $f64_t0 (type $f64_T) (i32.const -1))
  ;;(func $f64_t1 (type $f64_T) (i32.const -2))

  ;; The idea is: We reset the memory, then the instruction call $*_left,
  ;; $*_right, $*_another, $*_callee (for indirect calls), and $*_bool (when a
  ;; boolean value is needed). These functions all call bump, which shifts the
  ;; memory starting at address 8 up a byte, and then store a unique value at
  ;; address 8. Then we read the 4-byte value at address 8. It should contain
  ;; the correct sequence of unique values if the calls were evaluated in the
  ;; correct order.

  (func $reset (i32.store (i32.const 8) (i32.const 0)))

  (func $bump
    (i32.store8 (i32.const 11) (i32.load8_u (i32.const 10)))
    (i32.store8 (i32.const 10) (i32.load8_u (i32.const 9)))
    (i32.store8 (i32.const 9) (i32.load8_u (i32.const 8)))
    (i32.store8 (i32.const 8) (i32.const -3)))

  (func $get (result i32) (i32.load (i32.const 8)))

  (func $i32_left (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 1)) (i32.const 0))
  (func $i32_right (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 2)) (i32.const 1))
  (func $i32_another (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 3)) (i32.const 1))
  (func $i32_callee (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 4)) (i32.const 0))
  (func $i32_bool (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 5)) (i32.const 0))
  (func $i64_left (result i64) (call $bump) (i32.store8 (i32.const 8) (i32.const 1)) (i64.const 0))
  (func $i64_right (result i64) (call $bump) (i32.store8 (i32.const 8) (i32.const 2)) (i64.const 1))
  (func $i64_another (result i64) (call $bump) (i32.store8 (i32.const 8) (i32.const 3)) (i64.const 1))
  (func $i64_callee (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 4)) (i32.const 2))
  (func $i64_bool (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 5)) (i32.const 0))
  ;;(func $f32_left (result f32) (call $bump) (i32.store8 (i32.const 8) (i32.const 1)) (f32.const 0))
  ;;(func $f32_right (result f32) (call $bump) (i32.store8 (i32.const 8) (i32.const 2)) (f32.const 1))
  ;;(func $f32_another (result f32) (call $bump) (i32.store8 (i32.const 8) (i32.const 3)) (f32.const 1))
  ;;(func $f32_callee (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 4)) (i32.const 4))
  ;;(func $f32_bool (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 5)) (i32.const 0))
  ;;(func $f64_left (result f64) (call $bump) (i32.store8 (i32.const 8) (i32.const 1)) (f64.const 0))
  ;;(func $f64_right (result f64) (call $bump) (i32.store8 (i32.const 8) (i32.const 2)) (f64.const 1))
  ;;(func $f64_another (result f64) (call $bump) (i32.store8 (i32.const 8) (i32.const 3)) (f64.const 1))
  ;;(func $f64_callee (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 4)) (i32.const 6))
  ;;(func $f64_bool (result i32) (call $bump) (i32.store8 (i32.const 8) (i32.const 5)) (i32.const 0))
  (func $i32_dummy (param i32 i32))
  (func $i64_dummy (param i64 i64))
  ;;(func $f32_dummy (param f32 f32))
  ;;(func $f64_dummy (param f64 f64))

  (func (export "i32_add") (result i32) (call $reset) (drop (i32.add (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_sub") (result i32) (call $reset) (drop (i32.sub (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_mul") (result i32) (call $reset) (drop (i32.mul (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_div_s") (result i32) (call $reset) (drop (i32.div_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_div_u") (result i32) (call $reset) (drop (i32.div_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_rem_s") (result i32) (call $reset) (drop (i32.rem_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_rem_u") (result i32) (call $reset) (drop (i32.rem_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_and") (result i32) (call $reset) (drop (i32.and (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_or") (result i32) (call $reset) (drop (i32.or (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_xor") (result i32) (call $reset) (drop (i32.xor (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_shl") (result i32) (call $reset) (drop (i32.shl (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_shr_u") (result i32) (call $reset) (drop (i32.shr_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_shr_s") (result i32) (call $reset) (drop (i32.shr_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_eq") (result i32) (call $reset) (drop (i32.eq (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_ne") (result i32) (call $reset) (drop (i32.ne (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_lt_s") (result i32) (call $reset) (drop (i32.lt_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_le_s") (result i32) (call $reset) (drop (i32.le_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_lt_u") (result i32) (call $reset) (drop (i32.lt_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_le_u") (result i32) (call $reset) (drop (i32.le_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_gt_s") (result i32) (call $reset) (drop (i32.gt_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_ge_s") (result i32) (call $reset) (drop (i32.ge_s (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_gt_u") (result i32) (call $reset) (drop (i32.gt_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_ge_u") (result i32) (call $reset) (drop (i32.ge_u (call $i32_left) (call $i32_right))) (call $get))
  (func (export "i32_store") (result i32) (call $reset) (i32.store (call $i32_left) (call $i32_right)) (call $get))
  (func (export "i32_store8") (result i32) (call $reset) (i32.store8 (call $i32_left) (call $i32_right)) (call $get))
  (func (export "i32_store16") (result i32) (call $reset) (i32.store16 (call $i32_left) (call $i32_right)) (call $get))
  (func (export "i32_call") (result i32) (call $reset) (call $i32_dummy (call $i32_left) (call $i32_right)) (call $get))
  (func (export "i32_call_indirect") (result i32) (call $reset) (drop (call_indirect (type $i32_T) (call $i32_left) (call $i32_right) (call $i32_callee))) (call $get))
  (func (export "i32_select") (result i32) (call $reset) (drop (select (call $i32_left) (call $i32_right) (call $i32_bool))) (call $get))

  (func (export "i64_add") (result i32) (call $reset) (drop (i64.add (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_sub") (result i32) (call $reset) (drop (i64.sub (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_mul") (result i32) (call $reset) (drop (i64.mul (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_div_s") (result i32) (call $reset) (drop (i64.div_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_div_u") (result i32) (call $reset) (drop (i64.div_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_rem_s") (result i32) (call $reset) (drop (i64.rem_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_rem_u") (result i32) (call $reset) (drop (i64.rem_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_and") (result i32) (call $reset) (drop (i64.and (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_or") (result i32) (call $reset) (drop (i64.or (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_xor") (result i32) (call $reset) (drop (i64.xor (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_shl") (result i32) (call $reset) (drop (i64.shl (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_shr_u") (result i32) (call $reset) (drop (i64.shr_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_shr_s") (result i32) (call $reset) (drop (i64.shr_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_eq") (result i32) (call $reset) (drop (i64.eq (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_ne") (result i32) (call $reset) (drop (i64.ne (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_lt_s") (result i32) (call $reset) (drop (i64.lt_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_le_s") (result i32) (call $reset) (drop (i64.le_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_lt_u") (result i32) (call $reset) (drop (i64.lt_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_le_u") (result i32) (call $reset) (drop (i64.le_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_gt_s") (result i32) (call $reset) (drop (i64.gt_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_ge_s") (result i32) (call $reset) (drop (i64.ge_s (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_gt_u") (result i32) (call $reset) (drop (i64.gt_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_ge_u") (result i32) (call $reset) (drop (i64.ge_u (call $i64_left) (call $i64_right))) (call $get))
  (func (export "i64_store") (result i32) (call $reset) (i64.store (call $i32_left) (call $i64_right)) (call $get))
  (func (export "i64_store8") (result i32) (call $reset) (i64.store8 (call $i32_left) (call $i64_right)) (call $get))
  (func (export "i64_store16") (result i32) (call $reset) (i64.store16 (call $i32_left) (call $i64_right)) (call $get))
  (func (export "i64_store32") (result i32) (call $reset) (i64.store32 (call $i32_left) (call $i64_right)) (call $get))
  (func (export "i64_call") (result i32) (call $reset) (call $i64_dummy (call $i64_left) (call $i64_right)) (call $get))
  (func (export "i64_call_indirect") (result i32) (call $reset) (drop (call_indirect (type $i64_T) (call $i64_left) (call $i64_right) (call $i64_callee))) (call $get))
  (func (export "i64_select") (result i32) (call $reset) (drop (select (call $i64_left) (call $i64_right) (call $i64_bool))) (call $get))

  ;;(func (export "f32_add") (result i32) (call $reset) (drop (f32.add (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_sub") (result i32) (call $reset) (drop (f32.sub (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_mul") (result i32) (call $reset) (drop (f32.mul (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_div") (result i32) (call $reset) (drop (f32.div (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_copysign") (result i32) (call $reset) (drop (f32.copysign (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_eq") (result i32) (call $reset) (drop (f32.eq (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_ne") (result i32) (call $reset) (drop (f32.ne (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_lt") (result i32) (call $reset) (drop (f32.lt (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_le") (result i32) (call $reset) (drop (f32.le (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_gt") (result i32) (call $reset) (drop (f32.gt (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_ge") (result i32) (call $reset) (drop (f32.ge (call $f32_left) (call $f32_right))) (call $get))
  ;;(func (export "f32_min") (result i32) (call $reset) (drop (f32.min (call $f32_left) (call $f32_right))) (call $get))
(;
  (func (export "f32_max") (result i32) (call $reset) (drop (f32.max (call $f32_left) (call $f32_right))) (call $get))
  (func (export "f32_store") (result i32) (call $reset) (f32.store (call $i32_left) (call $f32_right)) (call $get))
  (func (export "f32_call") (result i32) (call $reset) (call $f32_dummy (call $f32_left) (call $f32_right)) (call $get))
  (func (export "f32_call_indirect") (result i32) (call $reset) (drop (call_indirect (type $f32_T) (call $f32_left) (call $f32_right) (call $f32_callee))) (call $get))
  (func (export "f32_select") (result i32) (call $reset) (drop (select (call $f32_left) (call $f32_right) (call $f32_bool))) (call $get))

  (func (export "f64_add") (result i32) (call $reset) (drop (f64.add (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_sub") (result i32) (call $reset) (drop (f64.sub (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_mul") (result i32) (call $reset) (drop (f64.mul (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_div") (result i32) (call $reset) (drop (f64.div (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_copysign") (result i32) (call $reset) (drop (f64.copysign (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_eq") (result i32) (call $reset) (drop (f64.eq (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_ne") (result i32) (call $reset) (drop (f64.ne (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_lt") (result i32) (call $reset) (drop (f64.lt (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_le") (result i32) (call $reset) (drop (f64.le (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_gt") (result i32) (call $reset) (drop (f64.gt (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_ge") (result i32) (call $reset) (drop (f64.ge (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_min") (result i32) (call $reset) (drop (f64.min (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_max") (result i32) (call $reset) (drop (f64.max (call $f64_left) (call $f64_right))) (call $get))
  (func (export "f64_store") (result i32) (call $reset) (f64.store (call $i32_left) (call $f64_right)) (call $get))
  (func (export "f64_call") (result i32) (call $reset) (call $f64_dummy (call $f64_left) (call $f64_right)) (call $get))
  (func (export "f64_call_indirect") (result i32) (call $reset) (drop (call_indirect (type $f64_T) (call $f64_left) (call $f64_right) (call $f64_callee))) (call $get))
  (func (export "f64_select") (result i32) (call $reset) (drop (select (call $f64_left) (call $f64_right) (call $f64_bool))) (call $get))
;)

  (func (export "br_if") (result i32)
    (block (result i32)
      (call $reset)
      (drop (br_if 0 (call $i32_left) (i32.and (call $i32_right) (i32.const 0))))
      (call $get)
    )
  )
  (func (export "br_table") (result i32)
    (block $a (result i32)
      (call $reset)
      (drop
        (block $b (result i32)
          (br_table $a $b (call $i32_left) (call $i32_right))
        )
      )
      (call $get)
    )
  )
)

(assert_return (invoke "i32_add") (i32.const 0x0102))     (assert_return (invoke "i64_add") (i32.const 0x0102))
(assert_return (invoke "i32_sub") (i32.const 0x0102))     (assert_return (invoke "i64_sub") (i32.const 0x0102))
(assert_return (invoke "i32_mul") (i32.const 0x0102))     (assert_return (invoke "i64_mul") (i32.const 0x0102))
(assert_return (invoke "i32_div_s") (i32.const 0x0102))   (assert_return (invoke "i64_div_s") (i32.const 0x0102))
(assert_return (invoke "i32_div_u") (i32.const 0x0102))   (assert_return (invoke "i64_div_u") (i32.const 0x0102))
(assert_return (invoke "i32_rem_s") (i32.const 0x0102))   (assert_return (invoke "i64_rem_s") (i32.const 0x0102))
(assert_return (invoke "i32_rem_u") (i32.const 0x0102))   (assert_return (invoke "i64_rem_u") (i32.const 0x0102))
(assert_return (invoke "i32_and") (i32.const 0x0102))     (assert_return (invoke "i64_and") (i32.const 0x0102))
(assert_return (invoke "i32_or") (i32.const 0x0102))      (assert_return (invoke "i64_or") (i32.const 0x0102))
(assert_return (invoke "i32_xor") (i32.const 0x0102))     (assert_return (invoke "i64_xor") (i32.const 0x0102))
(assert_return (invoke "i32_shl") (i32.const 0x0102))     (assert_return (invoke "i64_shl") (i32.const 0x0102))
(assert_return (invoke "i32_shr_u") (i32.const 0x0102))   (assert_return (invoke "i64_shr_u") (i32.const 0x0102))
(assert_return (invoke "i32_shr_s") (i32.const 0x0102))   (assert_return (invoke "i64_shr_s") (i32.const 0x0102))
(assert_return (invoke "i32_eq") (i32.const 0x0102))      (assert_return (invoke "i64_eq") (i32.const 0x0102))
(assert_return (invoke "i32_ne") (i32.const 0x0102))      (assert_return (invoke "i64_ne") (i32.const 0x0102))
(assert_return (invoke "i32_lt_s") (i32.const 0x0102))    (assert_return (invoke "i64_lt_s") (i32.const 0x0102))
(assert_return (invoke "i32_le_s") (i32.const 0x0102))    (assert_return (invoke "i64_le_s") (i32.const 0x0102))
(assert_return (invoke "i32_lt_u") (i32.const 0x0102))    (assert_return (invoke "i64_lt_u") (i32.const 0x0102))
(assert_return (invoke "i32_le_u") (i32.const 0x0102))    (assert_return (invoke "i64_le_u") (i32.const 0x0102))
(assert_return (invoke "i32_gt_s") (i32.const 0x0102))    (assert_return (invoke "i64_gt_s") (i32.const 0x0102))
(assert_return (invoke "i32_ge_s") (i32.const 0x0102))    (assert_return (invoke "i64_ge_s") (i32.const 0x0102))
(assert_return (invoke "i32_gt_u") (i32.const 0x0102))    (assert_return (invoke "i64_gt_u") (i32.const 0x0102))
(assert_return (invoke "i32_ge_u") (i32.const 0x0102))    (assert_return (invoke "i64_ge_u") (i32.const 0x0102))
(assert_return (invoke "i32_store") (i32.const 0x0102))   (assert_return (invoke "i64_store") (i32.const 0x0102))
(assert_return (invoke "i32_store8") (i32.const 0x0102))  (assert_return (invoke "i64_store8") (i32.const 0x0102))
(assert_return (invoke "i32_store16") (i32.const 0x0102)) (assert_return (invoke "i64_store16") (i32.const 0x0102))
(assert_return (invoke "i64_store32") (i32.const 0x0102))
(assert_return (invoke "i32_call") (i32.const 0x0102))    (assert_return (invoke "i64_call") (i32.const 0x0102))
(assert_return (invoke "i32_call_indirect") (i32.const 0x010204))
(assert_return (invoke "i64_call_indirect") (i32.const 0x010204))
(assert_return (invoke "i32_select") (i32.const 0x010205))  (assert_return (invoke "i64_select") (i32.const 0x010205))

(;
(assert_return (invoke "f32_add") (i32.const 0x0102))     (assert_return (invoke "f64_add") (i32.const 0x0102))
(assert_return (invoke "f32_sub") (i32.const 0x0102))     (assert_return (invoke "f64_sub") (i32.const 0x0102))
(assert_return (invoke "f32_mul") (i32.const 0x0102))     (assert_return (invoke "f64_mul") (i32.const 0x0102))
(assert_return (invoke "f32_div") (i32.const 0x0102))     (assert_return (invoke "f64_div") (i32.const 0x0102))
(assert_return (invoke "f32_copysign") (i32.const 0x0102))(assert_return (invoke "f64_copysign") (i32.const 0x0102))
(assert_return (invoke "f32_eq") (i32.const 0x0102))      (assert_return (invoke "f64_eq") (i32.const 0x0102))
(assert_return (invoke "f32_ne") (i32.const 0x0102))      (assert_return (invoke "f64_ne") (i32.const 0x0102))
(assert_return (invoke "f32_lt") (i32.const 0x0102))      (assert_return (invoke "f64_lt") (i32.const 0x0102))
(assert_return (invoke "f32_le") (i32.const 0x0102))      (assert_return (invoke "f64_le") (i32.const 0x0102))
(assert_return (invoke "f32_gt") (i32.const 0x0102))      (assert_return (invoke "f64_gt") (i32.const 0x0102))
(assert_return (invoke "f32_ge") (i32.const 0x0102))      (assert_return (invoke "f64_ge") (i32.const 0x0102))
(assert_return (invoke "f32_min") (i32.const 0x0102))     (assert_return (invoke "f64_min") (i32.const 0x0102))
(assert_return (invoke "f32_max") (i32.const 0x0102))     (assert_return (invoke "f64_max") (i32.const 0x0102))
(assert_return (invoke "f32_store") (i32.const 0x0102))   (assert_return (invoke "f64_store") (i32.const 0x0102))
(assert_return (invoke "f32_call") (i32.const 0x0102))    (assert_return (invoke "f64_call") (i32.const 0x0102))
(assert_return (invoke "f32_call_indirect") (i32.const 0x010204))
(assert_return (invoke "f64_call_indirect") (i32.const 0x010204))
(assert_return (invoke "f32_select") (i32.const 0x010205))  (assert_return (invoke "f64_select") (i32.const 0x010205))
;)

(assert_return (invoke "br_if") (i32.const 0x0102))
(assert_return (invoke "br_table") (i32.const 0x0102))
