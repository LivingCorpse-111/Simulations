using Plots
using DifferentialEquations

function relative_displacement(du, u, p, t)
    x, y, z , vx, vy, vz= u[1], u[2], u[3], u[4], u[5], u[6]
    du[1], du[2], du[3] = vx, vy, vz

    G, m1, m2 = p

    du[4] = -G* (m1+m2)* x / (x^2 + y^2 + z^2)^(3/2)
    du[5] = -G* (m1+m2)* y / (x^2 + y^2 + z^2)^(3/2)
    du[6] = -G* (m1+m2)* z / (x^2 + y^2 + z^2)^(3/2)
end

r1_0 = [0.1e7, 0.7e7, 0.2e7]
r2_0 = [-3.0e7, -3.0e7, -3.0e7]
r_0 = r2_0 .- r1_0

v1_0 = [2000,1500,150]
v2_0 = [0.0, 400.0, 2000.0] 
v_0 = v2_0 .- v1_0

u0 = [r_0[1], r_0[2], r_0[3], v_0[1], v_0[2], v_0[3]]

G  = 6.67428e-11
m1 = 6.0e24   # Mass of Earth (kg)
m2 = 7.0e23
p  = [G, m1, m2]

tspan = (0.0, 1000000.0)

prob = ODEProblem(relative_displacement, u0, tspan, p)

sol = solve(prob, Vern7(), reltol=1e-9, abstol=1e-9)

v_com = @. (m1 * v1_0 + m2 * v2_0) / (m1 + m2)

r_com_0 = @. (m1 * r1_0 + m2 * r2_0) / (m1 + m2)

trail1 = Vector{Float64}[]
trail2 = Vector{Float64}[]

zoom_radius = 80e6

anim = @animate for t in 0.0:1000.0:1000000.0

    r_com = @. r_com_0 + v_com * t
    r_1 = @. r_com - (m2 / (m1 + m2)) * sol(t)[1:3]
    r_2 = @. r_com + (m1 / (m1 + m2)) * sol(t)[1:3]

    plot3d(legend = false, background_color = :black, aspect_ratio = :equal, size=(1000, 1000), 
           xlims=(-3.0e7, 2.2e9), ylims=(-3.0e7, 2.2e9), zlims=(-3.0e7, 2.2e9), grid = false, axis = false
           ,camera=(45, 20)) 
    #=plot3d(legend = false, background_color = :black, aspect_ratio = :equal, size=(1000, 1000), 
           xlims=(r_com[1] - zoom_radius, r_com[1] + zoom_radius), 
           ylims=(r_com[2] - zoom_radius, r_com[2] + zoom_radius), 
           zlims=(r_com[3] - zoom_radius, r_com[3] + zoom_radius), 
           grid = false, axis = false, camera=(45, 20)) =#

    push!(trail1, r_1); push!(trail2, r_2)

    if length(trail1)>70
        popfirst!(trail1); popfirst!(trail2)
    end

    if length(trail1) >= 2
        plot3d!([x[1] for x in trail1], [y[2] for y in trail1], [z[3] for z in trail1], color = :crimson, linewidth = 2, alpha = 0.7)
        plot3d!([x[1] for x in trail2], [y[2] for y in trail2], [z[3] for z in trail2], color = "#03e3fc", linewidth = 2, alpha = 0.7)
    end

    scatter3d!([r_1[1]], [r_1[2]], [r_1[3]], marker = :circle, markercolor = :crimson, markerstrokecolor = :crimson, markersize = 7)
    scatter3d!([r_2[1]], [r_2[2]], [r_2[3]], marker = :circle, markercolor = "#03e3fc", markerstrokecolor = "#03e3fc", markersize = 4)

end

mp4(anim, "Two Body Problem (Not Zoomed).mp4", fps = 30)
