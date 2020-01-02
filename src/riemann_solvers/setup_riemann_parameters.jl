include("sod_shock.jl")
#include("cr_sod_shock_main.jl")
include("cr_sod_shock_noprepopulation.jl")
#include("cr_sod_shock_withprepopulation.jl")

function RiemannParameters(;rhol::Float64=1.0, rhor::Float64=0.125,      # density left and right (L&R)
                            Pl::Float64=0.0,   Pr::Float64=0.0,          # pressure L&R
                            Ul::Float64=0.0,   Ur::Float64=0.0,          # internal energy L&R
                            P_cr_l::Float64=0.0, P_cr_r::Float64=0.0,    # CR pressure L&R
                            E_cr_l::Float64=0.0, E_cr_r::Float64=0.0,    # CR energy L&R
                            Bl::Array{Float64,1} = zeros(3),             # B-field left
                            Br::Array{Float64,1} = zeros(3),             # B-field right
                            Mach::Float64=0.0,                           # target Mach number
                            t::Float64,                                  # time of the solution
                            x_contact::Float64=70.0,                     # position of the contact discontinuity along the tube
                            γ_th::Float64=5.0/3.0,                       # adiabatic index of the gas
                            γ_cr::Float64=4.0/3.0,                       # adiabatic index of CRs
                            Pe_ratio::Float64=0.01,                      # ratio of proton to electron energy in acceleration
                            thetaB::Float64=0.0,                         # angle between magnetic field and shock normal
                            theta_crit::Float64=(π/4.0),                 # critical angle for B/Shock angle efficiency
                            dsa_model::Int64=-1,                         # diffuse shock acceleration model
                            xs_first_guess::Float64=4.7)                 # first guess of the resulting shock compression


    # Error handling
    if (Pl == 0.0 && Ul == 0.0)
        error("Both Ul and Pl are zero! Plase supply initital pressure values.")
    end # error handling


    # pure hydro case -> no pre-existing CRs and no DSA model selected
    if ( (P_cr_l == 0.0 && P_cr_r == 0.0) ||
         (E_cr_l == 0.0 && E_cr_r == 0.0) ) &&
         dsa_model == -1

         @info "Setting up parameters for pure hydro Sod-shock."

         return SodParameters(rhol=rhol, rhor=rhor, Pl=Pl, Pr=Pr,
                              Ul=Ul, Ur=Ur, Mach=Mach, t=t,
                              x_contact=x_contact, γ_th=γ_th)

    elseif dsa_model != -1

        @info "Setting up parameters for Sod-shock with CR acceleration."

        if ( (P_cr_l == 0.0 && P_cr_r == 0.0) ||
             (E_cr_l == 0.0 && E_cr_r == 0.0) )

            @info "No seed CRs."
            return SodCRParameters_noCRs(rhol=rhol, rhor=rhor,
                                         Pl=Pl, Pr=Pr, Ul=Ul, Ur=Ur,
                                         Mach=Mach, t=t, x_contact=x_contact,
                                         Pe_ratio=Pe_ratio, γ_th=γ_th, γ_cr=γ_cr,
                                         thetaB=thetaB, theta_crit=theta_crit,
                                         dsa_model=dsa_model,
                                         xs_first_guess=xs_first_guess)
        else
            @info "With seed CRs."
            error("Sod shock with seed CRs not implemented yet!")
            # return SodCRParameters_withCRs(rhol=rhol, rhor=rhor,
            #                                Pl=Pl, Pr=Pr, Ul=Ul, Ur=Ur,
            #                                P_cr_l=P_cr_l, P_cr_r=P_cr_r,
            #                                E_cr_l=E_cr_l, E_cr_r=E_cr_r,
            #                                Mach=Mach, t=t, x_contact=x_contact,
            #                                Pe_ratio=Pe_ratio, γ_th=γ_th, γ_cr=γ_cr,
            #                                thetaB=thetaB, theta_crit=theta_crit,
            #                                dsa_model=dsa_model)
        end #
    end # dsa_model != -1

    if ( (P_cr_l != 0.0 && P_cr_r != 0.0) ||
         (E_cr_l != 0.0 && E_cr_r != 0.0) ) &&
         dsa_model == -1

         @info "Setting up parameters for multicomponent shock without CR acceleration."

         error("Multicomponent fluid shock not implemented yet!")
         # return SodCRParameters_withCRs(rhol=rhol, rhor=rhor, Pl=Pl, Pr=Pr,
         #                                 Ul=Ul, Ur=Ur, P_cr_l=P_cr_l, P_cr_r=P_cr_r,
         #                                 E_cr_l=E_cr_l, E_cr_r=E_cr_r,
         #                                 Mach=Mach, t=t, x_contact=x_contact,
         #                                 Pe_ratio=Pe_ratio, γ_th=γ_th, γ_cr=γ_cr,
         #                                 dsa_model=dsa_model)

    end # Seed CRs without acc

end # RiemannParameters


"""
    Multiple dispatch for solve function
"""
# Pure hydro Sod-shock
solve(x::Array{Float64,1}, par::SodParameters) = solveSodShock(x, par=par)
solve(x::Array{Float32,1}, par::SodParameters) = solveSodShock(Float64.(x), par=par)

# CR Sod shock
solve(x::Array{Float64,1}, par::SodCRParameters_noCRs)   = solveSodShockCR_noPrepopulation(x, par=par)
solve(x::Array{Float32,1}, par::SodCRParameters_noCRs)   = solveSodShockCR_noPrepopulation(Float64.(x), par=par)

# solve(x::Array{Float64,1}, par::SodCRParameters_withCRs) = solveSodShockCR_withPrepopulation(x, par=par)
# solve(x::Array{Float32,1}, par::SodCRParameters_withCRs) = solveSodShockCR_withPrepopulation(Float64.(x), par=par)