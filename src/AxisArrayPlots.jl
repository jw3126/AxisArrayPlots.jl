__precompile__(true)
module AxisArrayPlots

using AxisArrays
using RecipesBase

@recipe function plot{T}(arr::AxisArray{T, 1})
    xlabel --> axisnames(arr)[1]
    xrotation --> -45
    xs = first(axisvalues(arr))
    xs, arr.data
end

@recipe function plot{T}(arr::AxisArray{T, 2})
    xlbl, ylbl = axisnames(arr)
    xlabel --> xlbl
    ylabel --> ylbl
    xrotation --> -45
    axisvalues(arr)..., arr.data'
end

export Diff
struct Diff{T}
    aa1::AxisArray{T,1} where {T}
    aa2::AxisArray{T,1} where {T}
    normalize::Bool=false
    label1::String="y1"
    label2::String="y2"
    label_diff::String="diff"
end
function Diff(aa1,aa2;normalize=false,label1="y1",label2="y2",label_diff="diff")
    Diff(aa1,aa2,normalize,label1,label2,label_diff)
end

@recipe function plot(diff::Diff)
    title --> "Difference Plot"

    ft1 = diff.aa1
    ft2 = diff.aa2
    if diff.normalize
        # ft1 = broadcast!(similar(ft1), *, ft1, (1/maximum(ft1)) )
        # ft2 = broadcast!(similar(ft2), *, ft2, (1/maximum(ft2)) )
        ft1 = Base.normalize(ft1, Inf)
        ft2 = Base.normalize(ft2, Inf)
    end
    difference = ft1 - ft2
    @series begin
        label := diff.label1
        ft1
    end
    @series begin
        label := diff.label2
        ft2
    end
    @series begin
        label := diff.label_diff
        difference
    end
end

end
