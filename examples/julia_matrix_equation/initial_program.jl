using LinearAlgebra

# EVOLVE-BLOCK-START
function solve_quadratic_matrix_equation(
    A::AbstractMatrix{T},
    B::AbstractMatrix{T},
    C::AbstractMatrix{T};
    initial_guess=zeros(size(A)),
    tol=1e-14,
    max_iter=50000,
) where {T<:Real}
    F = lu(B)
    A_bar = F \ A
    C_bar = F \ C

    X = copy(initial_guess)
    X_new = similar(X)
    X2 = similar(X)
    diff = similar(X)

    for iter in 1:max_iter
        mul!(X2, X, X)         # X2 = X * X
        mul!(X_new, A_bar, X2) # X_new = A_bar * X2
        axpy!(1, C_bar, X_new) # X_new += C_bar
        lmul!(-1, X_new)       # X_new = -X_new

        copy!(diff, X_new)
        axpy!(-1, X, diff)

        if norm(diff) <= tol
            return X_new, iter
        end

        copy!(X, X_new)
    end

    return X, max_iter
end
# EVOLVE-BLOCK-END
