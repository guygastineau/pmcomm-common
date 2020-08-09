(library (display-format (1 0))
  (export display-format
          data-display-format
          format-display-data
          format-display-efficiency-data
          )
  (import (srfi srfi-1)
          (rnrs enums (6))
          (rnrs arithmetic bitwise (6))
          )

  ;; Add a better explanation once I know what this does ;)
  (define display-format
    (make-enumeration
     '(format-1
       format-2
       format-2b
       format-3
       format-4
       format-5
       format-6
       format-7
       format-8
       format-eff
       format-alarm
       format-invalid
       )))

  ;; Convert an address to a DISPLAY-FORMAT variant.
  (define (data-display-format addr)
    (case
     ((1 2 3 4)      'format-1)
     ((5 6 7 8 9 10) 'format-2)
     ((12 13)        'format-3)
     ((15)           'format-4)
     ((18 19)        'format-2b)
     ((23 24)        'format-2)
     ((21 22)        'format-5)
     ((26 27)        'format-6)
     ((28 29 30 31)  'format-7)
     ((25)           'format-8)
     ((215 218)      'format-eff)
     ((37)           'format-alarm)
     (else           'format-invalid)))

  ;; Transform data in byte vectors DATA and DATA-ALT into a 32 bit value
  ;; based on the DISPLAY-FORMAT variant FORMAT
  ;;
  ;; These transformations are all very imperative; they have been translated
  ;; directly from C code from John at Bogart Engineering. We should figure
  ;; out a Schemier way to do this.
  (define (format-display-data data data-alt format)
    (let (;; bitwise aliases
          (bor bitwise-or)
          (band bitwise-and)
          (shiftl bitwise-arithmetic-shift-left)
          (shiftr bitwise-arithmetic-shift-right)
          ;; bytevector aliases
          (byte-ref bytevector-u8-ref))
      (case format
        ;; FORMAT-1
        ((format-1)
         (bor
          (shiftr (byte-ref data 0) 1)
          (shiftl
           (band (byte-ref data 1) 7) 7)))
        ;; FORMAT-2 and FORMAT-2B
        ((format-2 format-2b)
         (let ((result
                (bor (bor (byte-ref data 0)
                          (shiftl (byte-ref data 1) 8))
                     (shiftl (byte-ref data 2)))))
           (begin
             (unless (zero?
                      (band (byte-ref data 2)
                            0x80))
               (set! result (bor result 0xff000000)))
             (set! result (- result))
             (if (zero? (byte-ref data-alt 0))
                 result
                 ;; Round | WTF that means with exact integers
                 (* (/ (+ result 5) 10) 10)))))
        ;; FORMAT-3
        ((format-3)
         (let ((result
                (bor (bor (byte-ref data 0)
                          (shiftl (byte-ref data 1) 8))
                     (shiftl (byte-ref data 2)))))
           (-
            (if (zero?
                 (band (byte-ref data 2)
                       0x80))
                result
                (bor result 0xff000000)))))
        ;; FORMAT-4
        ((format-4)
         (let ((result
                (bor
                 (bor (bor (shiftr (byte-ref data 0) 7)
                           (shiftl (byte-ref data 1) 1))
                      (shiftl (byte-ref data 2) 9))
                 (shiftl (byte-ref data 3) 17))))
           (-
            (if (zero?
                 (band (byte-ref data 3)
                       0x80))
                result
                (bor result 0xfe000000)))))
        ;; FORMAT-5
        ((format-6)
         (byte-ref data 0))
        ;; FORMAT-7
        ((format-7)
         (byte-vector-s8-ref data 0))
        ;; FORMAT-EFF
        ((format-eff)
         (error 'pm-error-badrequest "got 'format-eff"))
        ;; FORMAT-ALARM
        ((format-alarm)
         (bor
          (band (byte-ref data 0) 0x9f)
          (shiftl
           (band (byte-ref data 1) 0x1f)
           8)))
        (else
         (error 'pm-error-badrequest "Got invalid or unknown 'display-format")))))

  ;; We should a `record' to hold the Efficiency results.
  ;; Model it off of the PMEfficiency struct from the C code.
  ;; The actual C function for this takes an array of three `struct PMEfficiency`.
  ;; Maybe we will need a vector... ?
  ;; For now this is just a stub...
  (define (format-display-efficiency-data data)
    ;; Instead of taking pointers to the results
    ;; we can just construct those values and pass
    ;; out a vector or list of the records
    'unimplemented!)
  )
