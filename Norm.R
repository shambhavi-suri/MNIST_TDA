norm = function(p , Land)
{
  p <<- p #setting global variable
  fun_land = approxfun(x, Land, method = "linear") #linear interpolation to get 1st landscape
  fun_land_p = function(x)
  {
    fun_land(x)^p
  }
  #integrating f^p from 0 to 300
  integral_p = integrate(fun_land_p, lower= 0 , upper = 300)
  #the function returns pth root of integral
  (integral_p$value)^(1/p)
}