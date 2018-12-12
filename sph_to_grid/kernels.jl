mutable struct Cubic
    ngb::Int64
end

mutable struct Quintic
    ngb::Int64
end

mutable struct WendlandC4
    ngb::Int64
end

mutable struct WendlandC6
    ngb::Int64
end

function kernel_value(kernel::Cubic, u::Float64, h::Float64)

    norm = 8.0/π
    n = norm/h^3

    if u < 0.5
        return ( 1.0 + 6.0 * (u - 1.0) * u^2) * n
    elseif u < 1.0
        return ( 2.0 * (1.0 - u) * (1.0 - u) * (1.0 - u)) * n
    else
        return 0.
    end

end

function kernel_deriv(kernel::Cubic, u::Float64, h::Float64)

    norm = 8.0/π
    n = norm/h^4

    if u < 0.5
        return ( u * (18.0 * u - 12.0 )) * n
    elseif u < 1.0
        return ( -6.0 * (1.0 - u) * (1.0 - u) ) * n
    else
        return 0.
    end

end


function kernel_value(kernel::Quintic, u::Float64, h::Float64)

    norm = ( 2187.0 / ( 40. * π))
    n = norm/h^3

    if u < 1.0/3.0
        return ( ( 1.0 - u )^5 - 6.0 * ( 2.0/3.0 - u )^5  + 15.0 * ( 1.0/3.0 - u )^5 ) * n
    elseif u < 2.0/3.0
        return ( ( 1.0 - u )^5 - 6.0 * ( 2.0/3.0 - u )^5 ) * n
    elseif u < 1.0
        return ( ( 1.0 - u )^5 ) * n
    else
        return 0.
    end

end

function kernel_deriv(kernel::Quintic, u::Float64, h::Float64)

    norm = ( 2187.0 / ( 40. * π))
    n = norm/h^4

    if u < 1.0/3.0
        return ( -5.0 * ( 1.0 - u )^4 + 30.0 * ( 2.0/3.0 - u )^4  - 75.0 * ( 1.0/3.0 - u )^4 ) * n
    elseif u < 2.0/3.0
        return ( -5.0 * ( 1.0 - u )^4 + 30.0 * ( 2.0/3.0 - u )^4 - 75.0 ) * n
    elseif u < 1.0
        return ( -5.0 * ( 1.0 - u )^4 ) * n
    else
        return 0.
    end

end


function kernel_value(kernel::WendlandC4, u::Float64, h::Float64)

    norm = 495.0/(32. * π)
    n = norm/h^3

    if u < 1.0
        return ( ( 1. - u )^6 * ( 1.0 + 6.0 * u + 35.0/3.0 * u^2 ) ) * n
    else
        return 0.
    end

end

function kernel_deriv(kernel::WendlandC4, u::Float64, h::Float64)

    norm = 495.0/(32. * π)
    n = norm/h^4

    if u < 1.0
        return ( -288.0/3.0 * ( 1. - u )^5 * u^2 - 56.0/3.0 * u * ( 1. - u)^5 ) * n
    else
        return 0.
    end

end


function kernel_value(kernel::WendlandC6, u::Float64, h::Float64)

    norm = 1365.0/(64.0*π)
    n = norm/h^3

    if u < 1.0
        return ( (1.0 - u)^8 * ( 1.0 + 8. * u + 25. * u^2 + 32. * u^3 )) * n
    else
        return 0.
    end

end

function kernel_deriv(kernel::WendlandC6, u::Float64, h::Float64)

    norm = 1365.0/(64.0*π)
    n = norm/h^4

    if u < 1.0
        return ( -22. * (1.0 - u)^7 * u * ( 16. * u^2 + 7. * u + 1. )) * n
    else
        return 0.
    end

end
