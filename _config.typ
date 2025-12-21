
#let config = (
   colors: (
      link: blue,
      citation: gray,
      collatz: (
         arrow: luma(50),
         circle-fill: color.hsv(270deg, 25%, 100%),
         circle-stroke: color.hsv(270deg, 50%, 65%),
         text: luma(60)
      ),
      footer: (
         text: luma(100),
         line: luma(100)
      ),
      figure: (
         frame: gray
      ),
      quote: (
         fill: gray.lighten(80%),
         stroke: gray
      ),
      code: (
         inline-fill: luma(240)
      ),
      codly: (
         fill: luma(240),
         zebra-fill: luma(230),
         stroke: luma(160),
         line-numbers: luma(120)
      ),
      boxes: (
         info: (
            frame: rgb("#3b82f6"),
            fill: rgb("#e0f2ff"),
            title: rgb("#1d4ed8")
         ),
         code: (
            frame: rgb("#f6953b"),
            fill: rgb("#fff8e0"),
            title: rgb("#d87e1d")
         )
      )
   ),
   distances: (
      page: (
         margin-x: 1.5cm,
         margin-y: 1.5cm
      ),
      figure: (
         above: 2.0em,
         below: 3.0em
      ),
      heading: (
         above: 1.5em,
         below: 0.8em
      )
   ),
   document: (
      font-size: 13pt,
      footer: (
         font-size: 8pt
      ),
      figure: (
         caption-font-size: 10.5pt
      ),
      equation: (
         font-size: 1em
      )
   )
)