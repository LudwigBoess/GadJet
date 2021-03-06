"""
            Types needed for gadget read routines.

    Author: Ludwig Böss
    Contact: lboess@usm.lmu.de
    Created: 2018-12-12

"""

mutable struct Header
    npart::Vector{Int32}                # an array of particle numbers per type in this snapshot
    massarr::Vector{Float64}            # an array of particle masses per type in this snapshot - if zero: MASS block present
    time::Float64                       # time / scale factor of the simulation
    z::Float64                          # redshift of the simulation
    flag_sfr::Int32                     # 1 if simulation was run with star formation, else 0
    flag_feedback::Int32                # 1 if simulation was run with stellar feedback, else 0
    nall::Vector{UInt32}                # total number of particles in the simulation
    flag_cooling::Int32                 # 1 if simulation was run with cooling, else 0
    num_files::Int32                    # number of snapshots over which the simulation is distributed
    boxsize::Float64                    # total size of the simulation box
    omega_0::Float64                    # Omega matter
    omega_l::Float64                    # Omega dark enery
    h0::Float64                         # little h
    flag_stellarage::Int32              # 1 if simulation was run with stellar age, else 0
    flag_metals::Int32                  # 1 if simulation was run with metals, else 0
    npartTotalHighWord::Vector{UInt32}  # weird
    flag_entropy_instead_u::Int32       # 1 if snapshot U field contains entropy instead of internal energy, else 0
    flag_doubleprecision::Int32         # 1 if snapshot is in double precision, else 0
    flag_ic_info::Int32
    lpt_scalingfactor::Float32
    fill::Vector{Int32}                 # the HEAD block needs to be filled with zeros to have a size of 256 bytes

    function Header(npart::Vector{Int32}=Int32.([0,0,0,0,0,0]),
           massarr::Vector{Float64}=zeros(6),
           time::Float64=0.,
           z::Float64=0.,
           flag_sfr::Int32=Int32(0),
           flag_feedback::Int32=Int32(0),
           nall::Vector{UInt32}=UInt32.([0,0,0,0,0,0]),
           flag_cooling::Int32=Int32(0),
           num_files::Int32=Int32(0),
           boxsize::Float64=0.,
           omega_0::Float64=0.,
           omega_l::Float64=0.,
           h0::Float64=0.,
           flag_stellarage::Int32=Int32(0),
           flag_metals::Int32=Int32(0),
           npartTotalHighWord::Vector{UInt32}=UInt32.([0,0,0,0,0,0]),
           flag_entropy_instead_u::Int32=Int32(0),
           flag_doubleprecision::Int32=Int32(0),
           flag_ic_info::Int32=Int32(0),
           lpt_scalingfactor::Float32=Float32(0.),
           fill::Vector{Int32}=Int32.(zeros(12)))

          new(npart,
              massarr,
              time,
              z,
              flag_sfr,
              flag_feedback,
              nall,
              flag_cooling,
              num_files,
              boxsize,
              omega_0,
              omega_l,
              h0,
              flag_stellarage,
              flag_metals,
              npartTotalHighWord,
              flag_entropy_instead_u,
              flag_doubleprecision,
              flag_ic_info,
              lpt_scalingfactor,
              fill)
    end
end

mutable struct Info_Line
    block_name::String              # name of the data block, e.g. "POS"
    data_type::DataType             # datatype of the block, e.g. Float32 for single precision, Float64 for double
    n_dim::Int32                    # number of dimensions of the block, usually 1 or 3
    is_present::Vector{Int32}       # array of flags for which particle type this block is present,
                                    # e.g. gas only:  [ 1, 0, 0, 0, 0, 0 ]
                                    # e.g. gas + BHs: [ 1, 0, 0, 0, 0, 1 ]

    function Info_Line(block_name="", data_type=Float32, n_dim=Int32(0),
                        is_present=Int32.(zeros(6)))

        new(block_name, data_type, n_dim, is_present)
    end
end

mutable struct part_single
      ptype::Int64
      pos::Vector{Float32}
      vel::Vector{Float32}
      id::UInt32
      m::Float32
      U::Float32
      rho::Float32
      sml::Float32

      function part_single(ptype=-1, pos=Float32.(zeros(3)), vel=Float32.(zeros(3)),
                        id=UInt32(0), m=Float32(0.), U=Float32(0.), rho=Float32(0.),
                        sml=Float32(0.))

             new(ptype, pos, vel, id, m, U, rho, sml)

      end
end

mutable struct part_double
      ptype::Int64
      pos::Vector{Float64}
      vel::Vector{Float64}
      id::UInt32
      m::Float64
      U::Float64
      rho::Float64
      sml::Float64

      function part_double(ptype=-1, pos=zeros(3), vel=zeros(3),
                        id=UInt32(0), m=0., U=0., rho=0.,
                        sml=0.)

             new(ptype, pos, vel, id, m, U, rho, sml)

      end
end
