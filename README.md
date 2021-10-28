# ItemGenerator
tool for generating algebra exercises.
# Complexity management
Each item has its own complexity. The complexity of an item is a integer vector: each coordinate represents an item paramenter-
## Monomial complexity
The complexity for a monomial is a vector with three components: coefficient complexity, variable complexity and degree complexity.
(0,0,0): monomial is the number 1.
(1,0,0): monomial is an integer.
(0,1,0): monomial is a single variable of degree 1.
(0,0,1): ??? 