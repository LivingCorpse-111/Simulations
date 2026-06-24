using Plots
using DifferentialEquations

function pedndulum_ode(du, u, p, t)
    g, L = p

    #an important constraint : x^2 + y^2 + z^2 = L^2 = constant => x.vx + y.vy + z.vz = 0 should always be satisfied always

    x = u[1]
    y = u[2]
    z = u[3]
    vx = u[4]
    vy = u[5]
    vz = u[6]

    v_sq = vx^2 + vy^2 + vz^2
    k = (g * z - v_sq) / L^2

    du[1] = vx
    du[2] = vy
    du[3] = vz
    du[4] = k * x
    du[5] = k * y
    du[6] = k * z - g

end

u0 = [10.0, 10.0, -5.0, 4.0, -2.0, 4.0]

p = [9.8, 15]

timespan = (0, 180)

prob = ODEProblem(pedndulum_ode, u0, timespan, p)

sol = solve(prob, Vern7(), reltol=1e-9, abstol=1e-9)

trail_x = []
trail_y = []
trail_z = []

anim = @animate for t_current in 0.0:0.1:180.0

    plot3d(legend = false, background_color = :black, aspect_ratio = :equal, size=(800, 800), 
           xlims=(-25,25), ylims=(-25,25), zlims=(-20,20), grid = true, gridcolor = :grey50, gridalpha = 0.7, fg_color_axis = :white
           ,camera=(45, 20))

    current_state = sol(t_current)
    x = current_state[1]
    y = current_state[2]
    z = current_state[3]

    #= trail :
    push all x, y and z coordinates in to respected trail list 
    after 70 frames, old trial's 1st value is removed, then in the next frame new value + 69 old values are drawn, to give a fadng effect.
    a line can be drawn if there are atleast 2 points 
    =#
    push!(trail_x, x); push!(trail_y, y); push!(trail_z, z)

    if length(trail_x) > 70
        popfirst!(trail_x); popfirst!(trail_y); popfirst!(trail_z)
    end
    
    if length(trail_x) >=2
        plot3d!(trail_x, trail_y, trail_z, color = "#03e3fc", alpha = 0.7, linewidth = 2) 
    end

    #                                                    .....x......

    #= Drawing the anchor point , string and
    Rendering the bob every time =#
    scatter3d!([0.0], [0.0], [0.0], markersize = 4, markercolor = :white, markerstrokecolor = :white)

    plot3d!([x, 0.0], [y, 0.0], [z, 0.0], color = :white, markerstrokecolor = :white ,linewidth = 2)

    scatter3d!([x], [y], [z], markersize = 7, markercolor = :crimson, markerstrokecolor = :white, markerstrokewidth = 1)

    #                                                    .....x......

    #= 
    creating the shadow of motion and trail on z = -20
    =#
    scatter3d!([x], [y], [-20.0], markersize = 4, markercolor = :grey50, alpha = 0.5)
    
    if length(trail_x) >= 2
    plot3d!(trail_x, trail_y, fill(-20.0, length(trail_x)), color = :grey50, alpha = 0.5, linewidth = 1) #fill(-20.0, length(trail_x)) creates an array, where all the elements are -20.0 and length is of trail_x
    end

    #                                                    .....x......
   
end

mp4(anim, "pendulum.mp4", fps=60)
