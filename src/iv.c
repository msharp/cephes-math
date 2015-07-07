/*							iv.c
 *
 *	Modified Bessel function of noninteger order
 *
 *
 *
 * SYNOPSIS:
 *
 * double v, x, y, iv();
 *
 * y = iv( v, x );
 *
 *
 *
 * DESCRIPTION:
 *
 * Returns modified Bessel function of order v of the
 * argument.  If x is negative, v must be integer valued.
 *
 * The function is defined as Iv(x) = Jv( ix ).  It is
 * here computed in terms of the confluent hypergeometric
 * function, according to the formula
 *
 *              v  -x
 * Iv(x) = (x/2)  e   hyperg( v+0.5, 2v+1, 2x ) / md_gamma(v+1)
 *
 * If v is a negative integer, then v is replaced by -v.
 *
 *
 * ACCURACY:
 *
 * Tested at random points (v, x), with v between 0 and
 * 30, x between 0 and 28.
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    DEC       0,30          2000      3.1e-15     5.4e-16
 *    IEEE      0,30         10000      1.7e-14     2.7e-15
 *
 * Accuracy is diminished if v is near a negative integer.
 *
 * See also hyperg.c.
 *
 */
/*							iv.c	*/
/*	Modified Bessel function of noninteger order		*/
/* If x < 0, then v must be an integer. */


/*
Cephes Math Library Release 2.8:  June, 2000
Copyright 1984, 1987, 1988, 2000 by Stephen L. Moshier
*/


#include "mconf.h"
#ifdef ANSIPROT
extern double hyperg ( double, double, double );
extern double md_exp ( double );
extern double md_gamma ( double );
extern double md_log ( double );
extern double md_fabs ( double );
extern double md_floor ( double );
#else
double hyperg(), md_exp(), md_gamma(), md_log(), md_fabs(), md_floor();
#endif
extern double MACHEP, MAXNUM;

double iv( v, x )
double v, x;
{
int sign;
double t, ax;

/* If v is a negative integer, invoke symmetry */
t = md_floor(v);
if( v < 0.0 )
	{
	if( t == v )
		{
		v = -v;	/* symmetry */
		t = -t;
		}
	}
/* If x is negative, require v to be an integer */
sign = 1;
if( x < 0.0 )
	{
	if( t != v )
		{
		mtherr( "iv", DOMAIN );
		return( 0.0 );
		}
	if( v != 2.0 * md_floor(v/2.0) )
		sign = -1;
	}

/* Avoid logarithm singularity */
if( x == 0.0 )
	{
	if( v == 0.0 )
		return( 1.0 );
	if( v < 0.0 )
		{
		mtherr( "iv", OVERFLOW );
		return( MAXNUM );
		}
	else
		return( 0.0 );
	}

ax = md_fabs(x);
t = v * md_log( 0.5 * ax )  -  x;
t = sign * md_exp(t) / md_gamma( v + 1.0 );
ax = v + 0.5;
return( t * hyperg( ax,  2.0 * ax,  2.0 * x ) );
}