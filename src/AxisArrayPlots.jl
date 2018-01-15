__precompile__(true)
module AxisArrayPlots

using AxisArrays
using RecipesBase
using ArgCheck

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
    axisvalues(arr)..., arr.data
end

@userplot DiffPlot
@recipe function plot(x::DiffPlot; label1="y1", label2="y2", label_diff="diff", normalize=false)
    ft1, ft2 = x.args
    @argcheck ft1 isa AxisArray
    @argcheck ft2 isa AxisArray
    
    title --> "Difference Plot"

    if normalize
        # ft1 = broadcast!(similar(ft1), *, ft1, (1/maximum(ft1)) )
        # ft2 = broadcast!(similar(ft2), *, ft2, (1/maximum(ft2)) )
        ft1 = Base.normalize(ft1, Inf)
        ft2 = Base.normalize(ft2, Inf)
    end
    diff = ft1 - ft2
    @series begin
        label := label1
        ft1
    end
    @series begin
        label := label2
        ft2
    end
    @series begin
        label := label_diff
        diff
    end
end

end # module
