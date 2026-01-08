syms u y theta(y) Br
u = 1.5*(1-y^2)

eq = diff(theta,y,2)+Br*diff(u,y)^2 == 0
cond1 = theta(-1)==0;
cond2 = theta(1)==1;
theta_sol = dsolve(eq,[cond1,cond2])


theta_mean = int(theta_s*u,y,-1,1)/int(u,y,-1,1)
Nu_d_h = -subs(diff(theta_sol,y),y,1)/theta_mean
Nu_d_c = -subs(diff(theta_sol,y),y,-1)/theta_mean

Nu_d_h_infty = limit(Nu_d_h,Br,Inf)
Nu_d_c_infty = limit(Nu_d_c,Br,Inf)