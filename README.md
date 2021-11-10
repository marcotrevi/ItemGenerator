# ItemGenerator
tool for generating algebra exercises.
# Map of Mathematics
The user is greeted with a map: only some locations ("sites") are visible, the rest is covered in clouds. A road network connects the sites and the user can walk from one site to another. Each site is a collection of same-themed items. Completion of the basic items reveals new areas of the map.
# Upgrades, challenges, infopoints
On the map near the sites there are infopoints (marked by mascotte sprites) which display information and instructions.
When the user reaches certain levels upgrades are available.
## upgrades
- 50/50: 2 incorrect choices are revealed
- tip: time is blocked and a tip is displayed
- X-ray glasses: a streak of questions is given with the correct answer displayed
- scissors: number of question is reduced
## challenges
Each challenge done awards the user with a badge.
- first chalk (first item batch answered)

# Items
Items are grouped in sites on the map. I.e. the "arithmetic" class items are all grouped in the same spot. Some items may not be accessible on the first run because they may need some prerequisites or some other skill from other sites.
## class: nomenclature
- term 
- product
- quotient
- remainder
- factor
- base
- exponent
- reciprocal
- opposite
## class: arithmetic
- basic operations with integers
    - sum/difference
    - product/division
    - prime factorization
- basic operations with fractions
    - sum/difference
    - product/division
    - simplification
- powers of integers and fractions
    - evaluation
    - properties:
        - product/division of same-base powers
        - product/division of same-exponent powers
        - power of a power
- n-th roots
    - evaluation
    - taking in/out from roots
    - rationalization
- logarithms
    - evaluation
    - properties:
        - logarithm of a product/division
        - logarithm of a power
        - change of base
## class: algebra
- equations
    - linear
    - quadratic
- algebraic sum of monomials
- product of monomials
- division of monomials
- algebraic sum of polynomials
- product of polynomials
- division of polynomials
- notable products
- factorization
- zeros of polynomials
- operations with algebraic fractions
- algebraic fractions: field of existence
- algebraic fractions: zeros
## class: geometry
- basic properties of elementary 2D shapes
    - square
    - rectangle
    - circle
    - 90-30-60 triangle, 90-45-45 triangle, generic 90-triangle
- basic properties of 3D shapes
    - cube
    - parallelepiped
    - sphere
    - pyramid
    - cone
    - prism
## class: analysis
- functions
    - graph-expression matching
    - classification
        - algebraic
            - linear
            - quadratic
            - polynomial
            - rational
            - irrational
        - trascendental
            - goniometric
            - exponential
            - logarithmic
- derivatives
    - elementary derivatives
    - properties:
        - derivative of linear combination
        - derivative of product
        - chain rule
- integrals
    - primitives
    - definite integrals

# Complexity management
Each item has its own complexity. The complexity of an item is a integer vector: each coordinate represents an item paramenter.
The complexity vector gets updated depending on the user performance. If the user answers correctly a certain number of items with the same complexity, the complexity vector increases. (maybe one coordinate at a time?) If the user fails to answer correctly, complexity is lowered.
## Complexity flow
Each item generator accepts a complexity vector as a parameter.
Each item type has different components (monomials, polynomials, algebraic fractions etc) and has different ways of combining these compomnents, i.e. the permutations. The complexity vector accounts for both the complexity of each component and the complexity of the permutations.
## Monomial complexity
The complexity for a monomial is a vector with three components: coefficient complexity, variable complexity and degree complexity.
We agree to call a monomial "positive" if it has a positive coefficient.
- (0,0,0): monomial is the number 1.
- (1,0,0): monomial is an integer.
- (0,1,0): monomial is a single variable of degree 1.
- (0,0,1): ??? (makes no sense)

## Item complexity: case (x+y)(x-y) [sumDifference]
- components: monomial x, monomial y
- permutations

## Item complexity: case x^2-y^2 [differenceOfSquares]
- components: monomial x, monomial y
- permutations

## Item complexity: case (x+y)^2 [binomialSquareCompact]
- components: monomial x, monomial y
- permutations

## Item complexity: case x^2+y^2+2xy [binomialSquareExpanded]
- components: monomial x, monomial y
- permutations

