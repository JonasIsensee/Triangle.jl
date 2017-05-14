module Triangulate

include("call_native_iface.jl")
include("utils_methods.jl")

export basic_triangulation
export constrained_triangulation

function basic_triangulation(vertices::Array{Float64,2}, vertices_map::Array{Int64,1})
    flat_triangle_list = call_basic_triangulation(flat_vertices(vertices, vertices_map), Vector{Cint}(vertices_map))
    
    return triangle_list_from_marker(flat_triangle_list)
end

function constrained_triangulation(vertices::Array{Float64,2}, vertices_map::Array{Int64,1}, edges_list::Array{Int64,2})
    return constrained_triangulation(vertices, vertices_map, edges_list, Array{Bool,1}())
end

function constrained_triangulation(vertices::Array{Float64,2}, vertices_map::Array{Int64,1}, edges_list::Array{Int64,2}, edges_boundary::Array{Bool,1})
    flatted_vertices = flat_vertices(vertices, vertices_map)
    vector_map = Vector{Cint}(vertices_map)
    flatted_edges = flat_edges(edges_list)

    if length(edges_boundary) != size(edges_list)[1]
        flat_triangle_list = call_constrained_triangulation(
                flatted_vertices, 
                vector_map, 
                flatted_edges
            )
        return triangle_list_from_marker(flat_triangle_list)
    else
        flat_triangle_list = call_constrained_triangulation_bounded(
                flatted_vertices, 
                vector_map, 
                flatted_edges,
                Vector{Cint}(map(x -> x ? 1 : 0, edges_boundary))
            )
        return triangle_list_from_marker(flat_triangle_list)
    end
end

end