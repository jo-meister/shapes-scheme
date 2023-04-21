(define (perform . query)
    (if (not (eqv? (remainder (- (length query) 2) 3) 0))
        (display "Incorrect number of arguments.\n\n")
        (if (file-exists? (cadr query))
            (run (car query) (get-satisfying-shapes (get-shapes (cadr query)) (get-conditions (cdr (cdr query)) '())))
            (map display (list "Unable to open " (cadr query) " for reading.\n\n"))
        )
    )
)

(define (string-to-words str)
    (let loop ((i 0) (j 0) (words '()) (len (string-length str)))
        (cond
            ((>= j len) (if (= i j) words (cons (substring str i j) words)))
            ((char=? (string-ref str j) #\space) (loop (+ 1 j) (+ 1 j) (if (= i j) words (cons (substring str i j) words)) len))
            (else (loop i (+ 1 j) words len))
        )
    )
)

(define (get-shapes filename)
    (with-input-from-file filename
        (lambda ()
            (let loop ((shapes '()))
                (let ((line (read-line)))
                    (if (eof-object? line)
                        (reverse shapes)
                        (loop (cons (reverse (string-to-words (string-trim-right line))) shapes))
                    )
                )
            )
        )
    )
)

(define (get-conditions query conditions)
    (if (eqv? (length query) 0)
        (reverse conditions)
        (get-conditions (drop query 3) (cons (take query 3) conditions))
    )
)

(define (get-satisfying-shapes shapes conditions)
    (if (eqv? (length conditions) 0)
        shapes
        (get-satisfying-shapes (shapes-satisfying shapes '() (car (car conditions)) (car (cdr (car conditions))) (car (cdr (cdr (car conditions))))) (cdr conditions))
    )
)

(define (shapes-satisfying shapes satisfying condition op value)
    (if (eqv? (length shapes) 0)
        (reverse satisfying)
        (begin
            (cond
                ((string=? op "==")
                    (begin
                        (if (values-equal (car shapes) condition value)
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
                ((string=? op "!=")
                    (begin
                        (if (not (values-equal (car shapes) condition value))
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
                ((string=? op ">")
                    (begin
                        (if (value-greater (car shapes) condition value)
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
                ((string=? op "<=")
                    (begin
                        (if (not (value-greater (car shapes) condition value))
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
                ((string=? op "<")
                    (begin
                        (if (value-less (car shapes) condition value)
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
                ((string=? op ">=")
                    (begin
                        (if (not (value-less (car shapes) condition value))
                            (shapes-satisfying (cdr shapes) (cons (car shapes) satisfying) condition op value)
                            (shapes-satisfying (cdr shapes) satisfying condition op value)
                        )
                    )
                )
            )
        )
    )
)

(define (values-equal shape condition value)
    (cond
        ((string=? condition "type") (string=? (cadr shape) value))
        ((string=? condition "area") (eqv? (get-area (cadr shape) (cdr (cdr shape))) (+ value 0.0)))
        ((string=? condition "volume") (eqv? (get-volume (cadr shape) (cdr (cdr shape))) (+ value 0.0)))
    )
)

(define (value-greater shape condition value)
    (cond
        ((string=? condition "type") (string>? (cadr shape) value))
        ((string=? condition "area") (> (get-area (cadr shape) (cdr (cdr shape))) value))
        ((string=? condition "volume") (> (get-volume (cadr shape) (cdr (cdr shape))) value))
    )
)

(define (value-less shape condition value)
    (cond
        ((string=? condition "type") (string<? (cadr shape) value))
        ((string=? condition "area") (< (get-area (cadr shape) (cdr (cdr shape))) value))
        ((string=? condition "volume") (< (get-volume (cadr shape) (cdr (cdr shape))) value))
    )
)

(define pi 3.14159265358979323846)

(define (get-area shape dimensions)
    (define dims (map (lambda (x) (/ (round (* x 100.0)) 100.0)) (map string->number dimensions)))
    (cond 
        ((string=? shape "box") (+ (* 2 (car dims) (car (cdr dims))) (* 2 (car dims) (car (cdr (cdr dims)))) (* 2 (car (cdr dims)) (car (cdr (cdr dims))))))
        ((string=? shape "sphere") (* 4 pi (car dims) (car dims)))
        ((string=? shape "cylinder") (+ (* 2 pi (car dims) (car dims)) (* 2 pi (car dims) (car (cdr dims)))))
        ((string=? shape "torus") (* 4 pi pi (car dims) (car (cdr dims))))
    )
)

(define (get-volume shape dimensions)
    (define dims (map (lambda (x) (/ (round (* x 100.0)) 100.0)) (map string->number dimensions)))
    (cond
        ((string=? shape "box") (* (car dims) (car (cdr dims)) (car (cdr (cdr dims)))))
        ((string=? shape "sphere") (/ (* 4 pi (car dims) (car dims) (car dims)) 3))
        ((string=? shape "cylinder") (* pi (car dims) (car dims) (car (cdr dims))))
        ((string=? shape "torus") (* 2 pi pi (car dims) (car dims) (car (cdr dims))))
    )
)

(define (format-number num)
    (let ((int-part (floor num)) (frac-part (round (* 100 (abs (- num (floor num)))))))
        (remove-last-char (string-append (number->string int-part) (if (< frac-part 10) "0" "") (number->string frac-part)))
    )
)

(define (remove-last-char str)
    (substring str 0 (- (string-length str) 1))
)

(define (print-shape name shape dimensions)
    (define dims (map (lambda (x) (format-number (+ x 0.0))) (map string->number dimensions)))
    (cond
        ((string=? shape "box") (map display (list "Box: " name ", Length=" (car dims) ", Width=" (car (cdr dims)) ", Height=" (car (cdr (cdr dims))) "\n")))
        ((string=? shape "sphere") (map display (list "Sphere: " name ", Radius=" (car dims) "\n")))
        ((string=? shape "cylinder") (map display (list "Cylinder: " name ", Radius=" (car dims) ", Height=" (car (cdr dims)) "\n")))
        ((string=? shape "torus") (map display (list "Torus: " name ", Small Radius=" (car dims) ", Big Radius=" (car (cdr dims)) "\n")))
    )
    (map display (list "\tSurface Area: " (format-number (get-area shape dimensions)) ", Volume: " (format-number (get-volume shape dimensions)) "\n"))
)

(define (print shapes)
    (if (not (eqv? (length shapes) 0))
        (begin
            (print-shape (car (car shapes)) (car (cdr (car shapes))) (cdr (cdr (car shapes))))
            (print (cdr shapes))
        )
    )
)

(define (count shapes)
    (display "There are ")
    (display (length shapes))
    (display " shapes.\n")
)

(define (total shapes)
    (map display (list "total(Surface Area)=" (format-number (apply + (map (lambda (shape) (get-area (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
    (map display (list "total(Volume)" (format-number (apply + (map (lambda (shape) (get-volume (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
)

(define (avg shapes)
    (map display (list "avg(Surface Area)=" (format-number (/ (apply + (map (lambda (shape) (get-area (cadr shape) (cdr (cdr shape)))) shapes)) (length shapes))) "\n"))
    (map display (list "avg(Volume)=" (format-number (/ (apply + (map (lambda (shape) (get-volume (cadr shape) (cdr (cdr shape)))) shapes)) (length shapes))) "\n"))
)

(define (maximum shapes)
    (map display (list "max(Surface Area)=" (format-number (apply max (map (lambda (shape) (get-area (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
    (map display (list "max(Volume)=" (format-number (apply max (map (lambda (shape) (get-volume (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
)

(define (minimum shapes)
    (map display (list "min(Surface Area)=" (format-number (apply min (map (lambda (shape) (get-area (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
    (map display (list "min(Volume)=" (format-number (apply min (map (lambda (shape) (get-volume (cadr shape) (cdr (cdr shape)))) shapes))) "\n"))
)

(define (run command shapes)
    (if (eqv? (length shapes) 0)
        (display "There are no shapes satisfying the condition(s)\n\n")
        (begin
            (cond
                ((string=? command "print") (print shapes))
                ((string=? command "count") (count shapes))
                ((string=? command "total") (total shapes))
                ((string=? command "avg") (avg shapes))
                ((string=? command "max") (maximum shapes))
                ((string=? command "min") (minimum shapes))
            )
            (display "\n")
        )
    )
)