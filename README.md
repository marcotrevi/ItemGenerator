# ItemGenerator
tool for generating algebra exercises.
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

