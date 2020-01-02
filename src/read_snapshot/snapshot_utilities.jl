

function print_blocks(filename)

    f = open(filename)
    blocksize = read(f, Int32)

    if blocksize != 8
        return "Not possible - use snap_format 2!"
    end

    p = position(f)
    seek(f,4)

    blocks = []

    while eof(f) != true

        name = Char.(read!(f, Array{Int8,1}(undef,4)))
        blockname = String(name)

        blockname = strip(blockname)

        push!(blocks, blockname)

        p = position(f)
        seek(f,p+8)

        skipsize = read(f, Int32)

        p = position(f)
        seek(f,p+skipsize+8)

    end

    println("Found blocks: ")
    for block ∈ blocks
        println(block)
    end

    return blocks

end

function read_info(filename; verbose::Bool=false)

    f = open(filename)
    seek(f,4)

    while eof(f) != true

        name = Char.(read!(f, Array{Int8,1}(undef,4)))
        blockname = String(name)

        p = position(f)
        seek(f,p+8)

        skipsize = read(f, Int32)

        if blockname == "INFO"
            n_blocks = Int(skipsize/40) # one info line is 40 bytes
            arr_info = Array{Info_Line,1}(undef,n_blocks)

            for i = 1:n_blocks
                arr_info[i] = read_info_line(f)
            end # for

            close(f)

            if verbose == true
                println("Found Info block.\nEntries are:\n")
                for i ∈ 1:length(arr_info)
                    println(i, " - ", arr_info[i].block_name)
                end # for
            end # verbose

            return arr_info

        else
            p = position(f)
            seek(f,p+skipsize+8)
        end # if blockname == "INFO"

    end # while eof(f) != true

    println("No info block present!")

    return 1

end

function read_info_line(f)

    name = Char.(read!(f, Array{Int8,1}(undef,4)))
    blockname = String(name)

    block_name = strip(blockname)

    letters = read!(f, Array{Int8,1}(undef,8))
    letters = Char.(letters)
    letters = string.(letters)

    data_type = ""
    for i = 1:length(letters)
        data_type *= letters[i]
    end

    data_type = lowercase(strip(data_type))

    if data_type == "float" ||
       data_type == "floatn"
            dt = Float32
    elseif data_type == "long"
            dt = Int32
    elseif data_type == "llong"
            dt = Int64
    elseif data_type == "double" ||
           data_type == "doublen"
            dt = Float64
    end

    n_dim = read(f,Int32)

    is_present = read!(f, Array{Int32,1}(undef,6))

    in_l = Info_Line(block_name, dt, n_dim, is_present)

    return in_l
end