#lang at-exp slideshow

;; Example ppict slideshow

(require
  pict
  ppict/2
  pict-abbrevs pict-abbrevs/slideshow
  racket/draw
  racket/list
  racket/string
  racket/format
  racket/runtime-path
  plot/no-gui (except-in plot/utils min* max*)
  images/icons/style (only-in images/icons/symbol check-icon x-icon))

;; -----------------------------------------------------------------------------

;; margins

(define slide-top 8/100)
(define slide-left 12/100)
(define slide-right (- 1 slide-left))
(define slide-bottom 80/100)

(define slide-text-left (* 3/2 slide-left))
(define slide-text-right (- 1 slide-text-left))
(define slide-text-top (* 3 slide-top))
(define slide-text-bottom slide-bottom)

;; ppict coordinates

(define text-l-coord (coord slide-text-left slide-text-top 'lt #:sep (h%->pixels 3/100)))
(define text-r-coord (coord slide-text-right slide-text-top 'rt))
(define center-coord (coord 1/2 1/2 'cc))
(define heading-l-coord (coord slide-left slide-top 'lt))
(define heading-r-coord (coord slide-right slide-top 'rt))

;; spacers

(define small-x-sep (w%->pixels 5/100))
(define med-x-sep (w%->pixels 10/100))

(define small-y-sep (h%->pixels 5/100))
(define med-y-sep (h%->pixels 10/100))

;; colors

(define black (string->color% "black"))
(define gray (string->color% "light gray"))
(define white (string->color% "white"))
(define cammy-green (hex-triplet->color% #x85A564))
(define background-color cammy-green)

;; other helpers

(define-runtime-path src "src")

(define racket-logo (bitmap (build-path src "racket-logo.png")))

(define (icon-pict i #:height h)
  (bitmap (i #:material plastic-icon-material #:height h)))

(define (table2 kv**
                #:col-sep [pre-col-sep #f]
                #:row-sep [pre-row-sep #f]
                #:col-align [col-align lc-superimpose]
                #:row-align [row-align cc-superimpose])
  (define col-sep (or pre-col-sep 328/5))
  (define row-sep (or pre-row-sep 364/5))
  (table 2 (flatten kv**) col-align row-align col-sep row-sep))

;; -----------------------------------------------------------------------------

(define (do-show)
  (set-page-numbers-visible! #false)
  (set-spotlight-style! #:size 60 #:color (color%-update-alpha highlight-brush-color 0.6))
  (parameterize ((current-slide-assembler (slide-assembler/background (current-slide-assembler) #:color background-color)))
    (sec:title)
    (sec:ppict-basics)
    (sec:plot)
    (sec:end)
    (void)))

(define (sec:title)
  (pslide
    #:go (coord slide-left 30/100 'lt)
    @titlet{Title:  An Example ppict Slideshow}
    #:go (coord slide-text-right 50/100 'rt #:sep (h%->pixels 2/100))
    @t{Author 1}
    @t{Author 2}
    #:go (coord 1/2 slide-text-bottom 'cb)
    (hc-append @tt{(made with Racket } (scale-to-fit racket-logo @tt{X}) @tt{)}))
  (void))

(define (sec:ppict-basics)
  (let ((pp @t{progressively}))
    (pslide
      #:go heading-l-coord
      @bt{All About ppict}
      #:go text-l-coord
      @t{ppict is a library ...}
      #:next
      @t{for naming picts and arranging picts ...}
      #:next
      (hc-append @t{and building picts } (tag-pict pp 'P))
      #:next
      @t{(that is, step-by-step)}
      #:go (at-underline pp)
      (make-underline pp)))
  (let* ((a-fish (standard-fish (w%->pixels 15/100) (h%->pixels 14/100)))
         (a-pumpkin (jack-o-lantern (h%->pixels 13/100)))
         (fish-limit 5))
    (define (add-frame pp)
      (add-rounded-border
        #:radius 10
        #:background-color white
        #:frame-color black
        #:frame-width 6
        #:x-margin small-x-sep
        #:y-margin small-y-sep
        pp))
    (define (fish* i)
      (apply ht-append
             10
             (for/list ((j (in-range (sub1 fish-limit))))
               (if (< j i) a-fish (ghost a-fish)))))
    (pslide
      #:go heading-l-coord
      @bt{Fish => Pumpkin}
      #:go center-coord
      #:alt [(add-frame a-fish)]
      (add-frame a-pumpkin))
    (for ((i (in-range 1 (+ 1 fish-limit))))
      (pslide
        #:go heading-l-coord
        @bt{Fish* => Pumpkin}
        #:go center-coord
        (add-frame
          (if (= i fish-limit)
            (cc-superimpose (fish* 0) a-pumpkin)
            (fish* i))))))
  (pslide
    #:go heading-r-coord
    @bt{Try new things and have fun})
  (void))

(define (sec:plot)
  (define (money-plot f)
    (parameterize ((plot-x-ticks no-ticks)
                   (plot-y-ticks no-ticks)
                   (plot-font-size (current-font-size)))
      (add-rounded-border
        #:radius 0 #:frame-width 4 #:frame-color black
        (plot-pict
          (function f
                    #:width (h%->pixels 2/100)
                    #:alpha 0.6
                    #:color cammy-green)
          #:y-label #f
          #:x-label #f
          #:width (w%->pixels 26/100)
          #:height (h%->pixels 30/100)
          #:x-min 0
          #:x-max 12
          #:y-min 0
          #:y-max 20))))
  (pslide
    #:go heading-l-coord
    @bt{Money Plots}
    #:go (coord 1/2 slide-text-top 'ct)
    (table2
      (list
        (cons (money-plot (lambda (x) 1))
              (icon-pict x-icon #:height 120))
        (cons (money-plot (lambda (x) (expt x 2)))
              (icon-pict check-icon #:height 140)))))
  (void))

(define (racket-sunset w h)
  (define (draw-sunset dc dx dy)
    (define old-brush (send dc get-brush))
    (define old-pen (send dc get-pen))
    (send dc set-brush
          (new brush%
               [gradient
                (new linear-gradient%
                     [x0 dx] [y0 dy]
                     [x1 dx] [y1 (+ dy h)]
                     [stops (list (list 0 racket-red)
                                  (list 48/100 white)
                                  (list 52/100 white)
                                  (list 100/100 racket-blue))])]))
    (send dc set-pen (new pen% [width 0] [color black]))
    (define path (new dc-path%))
    (send path rectangle 0 0 w h)
    (send dc draw-path path dx dy)
    ;; --
    (send dc set-brush old-brush)
    (send dc set-pen old-pen))
  (dc draw-sunset w h))

(define (sec:end)
  (pslide
    #:go center-coord
    (racket-sunset (* 1.2 client-w) (* 1.2 client-h))
    #:go center-coord
    @titlet{The End})
  (void))

;; -----------------------------------------------------------------------------

(module+ main
  (do-show))

(module+ raco-pict
  (provide raco-pict)
  (define aspect 'fullscreen)
  (define-values [client-w client-h]
    (apply values (for/list ((f (in-list (list get-client-w get-client-h)))) (f #:aspect aspect))))
  (define raco-pict
    (ppict-do
      (filled-rectangle client-w client-h #:draw-border? #f #:color background-color)

      #:go (coord slide-text-left slide-text-top 'lt #:sep med-y-sep)
      @t{Hello this is an example picture}
      racket-logo


    )))


