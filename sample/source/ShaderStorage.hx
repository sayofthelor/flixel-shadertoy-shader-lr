package;

class ShaderStorage
{
	public static final roadToHell:Array<String> = [
		'
    const float PI=3.14159265358979323846;

    #define speed (iTime*0.2975)
    #define ground_x (1.0-0.325*sin(PI*speed*0.25))
    float ground_y=1.0;
    float ground_z=0.5;

    vec2 rotate(vec2 k,float t)
        {
        return vec2(cos(t)*k.x-sin(t)*k.y,sin(t)*k.x+cos(t)*k.y);
        }

    float draw_scene(vec3 p)
        {
        float tunnel_m=0.125*cos(PI*p.z*1.0+speed*4.0-PI);
        float tunnel1_p=2.0;
        float tunnel1_w=tunnel1_p*0.225;
        float tunnel1=length(mod(p.xy,tunnel1_p)-tunnel1_p*0.5)-tunnel1_w;	// tunnel1
        float tunnel2_p=2.0;
        float tunnel2_w=tunnel2_p*0.2125+tunnel2_p*0.0125*cos(PI*p.y*8.0)+tunnel2_p*0.0125*cos(PI*p.z*8.0);
        float tunnel2=length(mod(p.xy,tunnel2_p)-tunnel2_p*0.5)-tunnel2_w;	// tunnel2
        float hole1_p=1.0;
        float hole1_w=hole1_p*0.5;
        float hole1=length(mod(p.xz,hole1_p).xy-hole1_p*0.5)-hole1_w;	// hole1
        float hole2_p=0.25;
        float hole2_w=hole2_p*0.375;
        float hole2=length(mod(p.yz,hole2_p).xy-hole2_p*0.5)-hole2_w;	// hole2
        float hole3_p=0.5;
        float hole3_w=hole3_p*0.25+0.125*sin(PI*p.z*2.0);
        float hole3=length(mod(p.xy,hole3_p).xy-hole3_p*0.5)-hole3_w;	// hole3
        float tube_m=0.075*sin(PI*p.z*1.0);
        float tube_p=0.5+tube_m;
        float tube_w=tube_p*0.025+0.00125*cos(PI*p.z*128.0);
        float tube=length(mod(p.xy,tube_p)-tube_p*0.5)-tube_w;			// tube
        float bubble_p=0.05;
        float bubble_w=bubble_p*0.5+0.025*cos(PI*p.z*2.0);
        float bubble=length(mod(p.yz,bubble_p)-bubble_p*0.5)-bubble_w;	// bubble
        return max(min(min(-tunnel1,mix(tunnel2,-bubble,0.375)),max(min(-hole1,hole2),-hole3)),-tube);
        }

    void mainImage( out vec4 fragColor, in vec2 fragCoord )
        {
        vec2 position=(fragCoord.xy/iResolution.xy);
        vec2 p=-1.0+2.0*position;
        vec3 dir=normalize(vec3(p*vec2(1.77,1.0),1.0));		// screen ratio (x,y) fov (z)
        //dir.yz=rotate(dir.yz,PI*0.5*sin(PI*speed*0.125));	// rotation x
        dir.zx=rotate(dir.zx,-PI*speed*0.25);				// rotation y
        dir.xy=rotate(dir.xy,-speed*0.5);					// rotation z
        vec3 ray=vec3(ground_x,ground_y,ground_z-speed*2.5);
        float t=0.0;
        const int ray_n=96;
        for(int i=0;i<ray_n;i++)
            {
            float k=draw_scene(ray+dir*t);
            t+=k*0.75;
            }
        vec3 hit=ray+dir*t;
        vec2 h=vec2(-0.0025,0.002); // light
        vec3 n=normalize(vec3(draw_scene(hit+h.xyx),draw_scene(hit+h.yxy),draw_scene(hit+h.yyx)));
        float c=(n.x+n.y+n.z)*0.35;
        vec3 color=vec3(c,c,c)+t*0.0625;
        fragColor=vec4(vec3(c-t*0.0375+p.y*0.05,c-t*0.025-p.y*0.0625,c+t*0.025-p.y*0.025)+color*color,1.0);
        }
        ',
		'https://www.shadertoy.com/view/Mds3Rn'
	];

	public static final pyramids:Array<String> = [
		'vec3 palette(float d){
        return mix(vec3(0.2,0.7,0.9),vec3(1.,0.,1.),d);
    }

    vec2 rotate(vec2 p,float a){
        float c = cos(a);
        float s = sin(a);
        return p*mat2(c,s,-s,c);
    }

    float map(vec3 p){
        for( int i = 0; i<8; ++i){
            float t = iTime*0.2;
            p.xz =rotate(p.xz,t);
            p.xy =rotate(p.xy,t*1.89);
            p.xz = abs(p.xz);
            p.xz-=.5;
        }
        return dot(sign(p),p)/5.;
    }

    vec4 rm (vec3 ro, vec3 rd){
        float t = 0.;
        vec3 col = vec3(0.);
        float d;
        for(float i =0.; i<64.; i++){
            vec3 p = ro + rd*t;
            d = map(p)*.5;
            if(d<0.02){
                break;
            }
            if(d>100.){
                break;
            }
            //col+=vec3(0.6,0.8,0.8)/(400.*(d));
            col+=palette(length(p)*.1)/(400.*(d));
            t+=d;
        }
        return vec4(col,1./(d*100.));
    }
    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
        vec2 uv = (fragCoord-(iResolution.xy/2.))/iResolution.x;
        vec3 ro = vec3(0.,0.,-50.);
        ro.xz = rotate(ro.xz,iTime);
        vec3 cf = normalize(-ro);
        vec3 cs = normalize(cross(cf,vec3(0.,1.,0.)));
        vec3 cu = normalize(cross(cf,cs));
        
        vec3 uuv = ro+cf*3. + uv.x*cs + uv.y*cu;
        
        vec3 rd = normalize(uuv-ro);
        
        vec4 col = rm(ro,rd);
        
        
        fragColor = col;
    }

    /** SHADERDATA
    {
        "title": "fractal pyramid",
        "description": "",
        "model": "car"
    }
    */',
		'https://www.shadertoy.com/view/tsXBzS'
	];

	public static final seascape:Array<String> = [
		'/*
    * "Seascape" by Alexander Alekseev aka TDM - 2014
    * License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
    * Contact: tdmaav@gmail.com
    */

    const int NUM_STEPS = 8;
    const float PI	 	= 3.141592;
    const float EPSILON	= 1e-3;
    #define EPSILON_NRM (0.1 / iResolution.x)
    #define AA

    // sea
    const int ITER_GEOMETRY = 3;
    const int ITER_FRAGMENT = 5;
    const float SEA_HEIGHT = 0.6;
    const float SEA_CHOPPY = 4.0;
    const float SEA_SPEED = 0.8;
    const float SEA_FREQ = 0.16;
    const vec3 SEA_BASE = vec3(0.0,0.09,0.18);
    const vec3 SEA_WATER_COLOR = vec3(0.8,0.9,0.6)*0.6;
    #define SEA_TIME (1.0 + iTime * SEA_SPEED)
    const mat2 octave_m = mat2(1.6,1.2,-1.2,1.6);

    // math
    mat3 fromEuler(vec3 ang) {
        vec2 a1 = vec2(sin(ang.x),cos(ang.x));
        vec2 a2 = vec2(sin(ang.y),cos(ang.y));
        vec2 a3 = vec2(sin(ang.z),cos(ang.z));
        mat3 m;
        m[0] = vec3(a1.y*a3.y+a1.x*a2.x*a3.x,a1.y*a2.x*a3.x+a3.y*a1.x,-a2.y*a3.x);
        m[1] = vec3(-a2.y*a1.x,a1.y*a2.y,a2.x);
        m[2] = vec3(a3.y*a1.x*a2.x+a1.y*a3.x,a1.x*a3.x-a1.y*a3.y*a2.x,a2.y*a3.y);
        return m;
    }
    float hash( vec2 p ) {
        float h = dot(p,vec2(127.1,311.7));	
        return fract(sin(h)*43758.5453123);
    }
    float noise( in vec2 p ) {
        vec2 i = floor( p );
        vec2 f = fract( p );	
        vec2 u = f*f*(3.0-2.0*f);
        return -1.0+2.0*mix( mix( hash( i + vec2(0.0,0.0) ), 
                        hash( i + vec2(1.0,0.0) ), u.x),
                    mix( hash( i + vec2(0.0,1.0) ), 
                        hash( i + vec2(1.0,1.0) ), u.x), u.y);
    }

    // lighting
    float diffuse(vec3 n,vec3 l,float p) {
        return pow(dot(n,l) * 0.4 + 0.6,p);
    }
    float specular(vec3 n,vec3 l,vec3 e,float s) {    
        float nrm = (s + 8.0) / (PI * 8.0);
        return pow(max(dot(reflect(e,n),l),0.0),s) * nrm;
    }

    // sky
    vec3 getSkyColor(vec3 e) {
        e.y = (max(e.y,0.0)*0.8+0.2)*0.8;
        return vec3(pow(1.0-e.y,2.0), 1.0-e.y, 0.6+(1.0-e.y)*0.4) * 1.1;
    }

    // sea
    float sea_octave(vec2 uv, float choppy) {
        uv += noise(uv);        
        vec2 wv = 1.0-abs(sin(uv));
        vec2 swv = abs(cos(uv));    
        wv = mix(wv,swv,wv);
        return pow(1.0-pow(wv.x * wv.y,0.65),choppy);
    }

    float map(vec3 p) {
        float freq = SEA_FREQ;
        float amp = SEA_HEIGHT;
        float choppy = SEA_CHOPPY;
        vec2 uv = p.xz; uv.x *= 0.75;
        
        float d, h = 0.0;    
        for(int i = 0; i < ITER_GEOMETRY; i++) {        
            d = sea_octave((uv+SEA_TIME)*freq,choppy);
            d += sea_octave((uv-SEA_TIME)*freq,choppy);
            h += d * amp;        
            uv *= octave_m; freq *= 1.9; amp *= 0.22;
            choppy = mix(choppy,1.0,0.2);
        }
        return p.y - h;
    }

    float map_detailed(vec3 p) {
        float freq = SEA_FREQ;
        float amp = SEA_HEIGHT;
        float choppy = SEA_CHOPPY;
        vec2 uv = p.xz; uv.x *= 0.75;
        
        float d, h = 0.0;    
        for(int i = 0; i < ITER_FRAGMENT; i++) {        
            d = sea_octave((uv+SEA_TIME)*freq,choppy);
            d += sea_octave((uv-SEA_TIME)*freq,choppy);
            h += d * amp;        
            uv *= octave_m; freq *= 1.9; amp *= 0.22;
            choppy = mix(choppy,1.0,0.2);
        }
        return p.y - h;
    }

    vec3 getSeaColor(vec3 p, vec3 n, vec3 l, vec3 eye, vec3 dist) {  
        float fresnel = clamp(1.0 - dot(n,-eye), 0.0, 1.0);
        fresnel = pow(fresnel,3.0) * 0.5;
            
        vec3 reflected = getSkyColor(reflect(eye,n));    
        vec3 refracted = SEA_BASE + diffuse(n,l,80.0) * SEA_WATER_COLOR * 0.12; 
        
        vec3 color = mix(refracted,reflected,fresnel);
        
        float atten = max(1.0 - dot(dist,dist) * 0.001, 0.0);
        color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
        
        color += vec3(specular(n,l,eye,60.0));
        
        return color;
    }

    // tracing
    vec3 getNormal(vec3 p, float eps) {
        vec3 n;
        n.y = map_detailed(p);    
        n.x = map_detailed(vec3(p.x+eps,p.y,p.z)) - n.y;
        n.z = map_detailed(vec3(p.x,p.y,p.z+eps)) - n.y;
        n.y = eps;
        return normalize(n);
    }

    float heightMapTracing(vec3 ori, vec3 dir, out vec3 p) {  
        float tm = 0.0;
        float tx = 1000.0;    
        float hx = map(ori + dir * tx);
        if(hx > 0.0) {
            p = ori + dir * tx;
            return tx;   
        }
        float hm = map(ori + dir * tm);    
        float tmid = 0.0;
        for(int i = 0; i < NUM_STEPS; i++) {
            tmid = mix(tm,tx, hm/(hm-hx));                   
            p = ori + dir * tmid;                   
            float hmid = map(p);
            if(hmid < 0.0) {
                tx = tmid;
                hx = hmid;
            } else {
                tm = tmid;
                hm = hmid;
            }
        }
        return tmid;
    }

    vec3 getPixel(in vec2 coord, float time) {    
        vec2 uv = coord / iResolution.xy;
        uv = uv * 2.0 - 1.0;
        uv.x *= iResolution.x / iResolution.y;    
            
        // ray
        vec3 ang = vec3(sin(time*3.0)*0.1,sin(time)*0.2+0.3,time);    
        vec3 ori = vec3(0.0,3.5,time*5.0);
        vec3 dir = normalize(vec3(uv.xy,-2.0)); dir.z += length(uv) * 0.14;
        dir = normalize(dir) * fromEuler(ang);
        
        // tracing
        vec3 p;
        heightMapTracing(ori,dir,p);
        vec3 dist = p - ori;
        vec3 n = getNormal(p, dot(dist,dist) * EPSILON_NRM);
        vec3 light = normalize(vec3(0.0,1.0,0.8)); 
                
        // color
        return mix(
            getSkyColor(dir),
            getSeaColor(p,n,light,dir,dist),
            pow(smoothstep(0.0,-0.02,dir.y),0.2));
    }

    // main
    void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
        float time = iTime * 0.3;
        
    #ifdef AA
        vec3 color = vec3(0.0);
        for(int i = -1; i <= 1; i++) {
            for(int j = -1; j <= 1; j++) {
                vec2 uv = fragCoord+vec2(i,j)/3.0;
                color += getPixel(uv, time);
            }
        }
        color /= 9.0;
    #else
        vec3 color = getPixel(fragCoord, time);
    #endif
        
        // post
        fragColor = vec4(pow(color,vec3(0.65)), 1.0);
    }',
		'https://www.shadertoy.com/view/Ms2SD1'
	];

	public static var galaxy:Array<String> = [
		'// Galaxy shader
        //
        // Created by Frank Hugenroth  /frankenburgh/   07/2015
        // Released at nordlicht/bremen 2015

        #define SCREEN_EFFECT 0

        // random/hash function              
        float hash( float n )
        {
        return fract(cos(n)*41415.92653);
        }

        // 2d noise function
        float noise( in vec2 x )
        {
        vec2 p  = floor(x);
        vec2 f  = smoothstep(0.0, 1.0, fract(x));
        float n = p.x + p.y*57.0;

        return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
            mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
        }

        float noise( in vec3 x )
        {
        vec3 p  = floor(x);
        vec3 f  = smoothstep(0.0, 1.0, fract(x));
        float n = p.x + p.y*57.0 + 113.0*p.z;

        return mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
            mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
            mix(mix( hash(n+113.0), hash(n+114.0),f.x),
            mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
        }

        mat3 m = mat3( 0.00,  1.60,  1.20, -1.60,  0.72, -0.96, -1.20, -0.96,  1.28 );

        // Fractional Brownian motion
        float fbmslow( vec3 p )
        {
        float f = 0.5000*noise( p ); p = m*p*1.2;
        f += 0.2500*noise( p ); p = m*p*1.3;
        f += 0.1666*noise( p ); p = m*p*1.4;
        f += 0.0834*noise( p ); p = m*p*1.84;
        return f;
        }

        float fbm( vec3 p )
        {
        float f = 0., a = 1., s=0.;
        f += a*noise( p ); p = m*p*1.149; s += a; a *= .75;
        f += a*noise( p ); p = m*p*1.41; s += a; a *= .75;
        f += a*noise( p ); p = m*p*1.51; s += a; a *= .65;
        f += a*noise( p ); p = m*p*1.21; s += a; a *= .35;
        f += a*noise( p ); p = m*p*1.41; s += a; a *= .75;
        f += a*noise( p ); 
        return f/s;
        }



        void mainImage( out vec4 fragColor, in vec2 fragCoord )
        {
            float time = iTime * 0.1;

            vec2 xy = -1.0 + 2.0*fragCoord.xy / iResolution.xy;

            // fade in (1=10sec), out after 8=80sec;
            float fade = min(1., time*1.)*min(1.,max(0., 15.-time));
            // start glow after 5=50sec
            float fade2= max(0., time-10.)*0.37;
            float glow = max(-.25,1.+pow(fade2, 10.) - 0.001*pow(fade2, 25.));
            
            
            // get camera position and view direction
            vec3 campos = vec3(500.0, 850., -.0-cos((time-1.4)/2.)*2000.); // moving
            vec3 camtar = vec3(0., 0., 0.);
            
            float roll = 0.34;
            vec3 cw = normalize(camtar-campos);
            vec3 cp = vec3(sin(roll), cos(roll),0.0);
            vec3 cu = normalize(cross(cw,cp));
            vec3 cv = normalize(cross(cu,cw));
            vec3 rd = normalize( xy.x*cu + xy.y*cv + 1.6*cw );

            vec3 light   = normalize( vec3(  0., 0.,  0. )-campos );
            float sundot = clamp(dot(light,rd),0.0,1.0);

            // render sky

            // galaxy center glow
            vec3 col = glow*1.2*min(vec3(1.0, 1.0, 1.0), vec3(2.0,1.0,0.5)*pow( sundot, 100.0 ));
            // moon haze
            col += 0.3*vec3(0.8,0.9,1.2)*pow( sundot, 8.0 );

            // stars
            vec3 stars = 85.5*vec3(pow(fbmslow(rd.xyz*312.0), 7.0))*vec3(pow(fbmslow(rd.zxy*440.3), 8.0));
            
            // moving background fog
            vec3 cpos = 1500.*rd + vec3(831.0-time*30., 321.0, 1000.0);
            col += vec3(0.4, 0.5, 1.0) * ((fbmslow( cpos*0.0035 ) - .5));

            cpos += vec3(831.0-time*33., 321.0, 999.);
            col += vec3(0.6, 0.3, 0.6) * 10.0*pow((fbmslow( cpos*0.0045 )), 10.0);

            cpos += vec3(3831.0-time*39., 221.0, 999.0);
            col += 0.03*vec3(0.6, 0.0, 0.0) * 10.0*pow((fbmslow( cpos*0.0145 )), 2.0);

            // stars
            cpos = 1500.*rd + vec3(831.0, 321.0, 999.);
            col += stars*fbm(cpos*0.0021);
            
            
            // Clouds
            vec2 shift = vec2( time*100.0, time*180.0 );
            vec4 sum = vec4(0,0,0,0); 
            float c = campos.y / rd.y; // cloud height
            vec3 cpos2 = campos - c*rd;
            float radius = length(cpos2.xz)/1000.0;

            if (radius<1.8)
            {
            for (int q=10; q>-10; q--) // layers
            {
                if (sum.w>0.999) continue;
                float c = (float(q)*8.-campos.y) / rd.y; // cloud height
                vec3 cpos = campos + c*rd;

                float see = dot(normalize(cpos), normalize(campos));
                vec3 lightUnvis = vec3(.0,.0,.0 );
                vec3 lightVis   = vec3(1.3,1.2,1.2 );
                vec3 shine = mix(lightVis, lightUnvis, smoothstep(0.0, 1.0, see));

                // border
                float radius = length(cpos.xz)/999.;
                if (radius>1.0)
                continue;

                float rot = 3.00*(radius)-time;
                cpos.xz = cpos.xz*mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
            
                cpos += vec3(831.0+shift.x, 321.0+float(q)*mix(250.0, 50.0, radius)-shift.x*0.2, 1330.0+shift.y); // cloud position
                cpos *= mix(0.0025, 0.0028, radius); // zoom
                float alpha = smoothstep(0.50, 1.0, fbm( cpos )); // fractal cloud density
                alpha *= 1.3*pow(smoothstep(1.0, 0.0, radius), 0.3); // fade out disc at edges
                vec3 dustcolor = mix(vec3( 2.0, 1.3, 1.0 ), vec3( 0.1,0.2,0.3 ), pow(radius, .5));
                vec3 localcolor = mix(dustcolor, shine, alpha); // density color white->gray
                
                float gstar = 2.*pow(noise( cpos*21.40 ), 22.0);
                float gstar2= 3.*pow(noise( cpos*26.55 ), 34.0);
                float gholes= 1.*pow(noise( cpos*11.55 ), 14.0);
                localcolor += vec3(1.0, 0.6, 0.3)*gstar;
                localcolor += vec3(1.0, 1.0, 0.7)*gstar2;
                localcolor -= gholes;
                
                alpha = (1.0-sum.w)*alpha; // alpha/density saturation (the more a cloud layer\\\'s density, the more the higher layers will be hidden)
                sum += vec4(localcolor*alpha, alpha); // sum up weightened color
            }
                
            for (int q=0; q<20; q++) // 120 layers
            {
                if (sum.w>0.999) continue;
                float c = (float(q)*4.-campos.y) / rd.y; // cloud height
                vec3 cpos = campos + c*rd;

                float see = dot(normalize(cpos), normalize(campos));
                vec3 lightUnvis = vec3(.0,.0,.0 );
                vec3 lightVis   = vec3(1.3,1.2,1.2 );
                vec3 shine = mix(lightVis, lightUnvis, smoothstep(0.0, 1.0, see));

                // border
                float radius = length(cpos.xz)/200.0;
                if (radius>1.0)
                continue;

                float rot = 3.2*(radius)-time*1.1;
                cpos.xz = cpos.xz*mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
            
                cpos += vec3(831.0+shift.x, 321.0+float(q)*mix(250.0, 50.0, radius)-shift.x*0.2, 1330.0+shift.y); // cloud position
                float alpha = 0.1+smoothstep(0.6, 1.0, fbm( cpos )); // fractal cloud density
                alpha *= 1.2*(pow(smoothstep(1.0, 0.0, radius), 0.72) - pow(smoothstep(1.0, 0.0, radius*1.875), 0.2)); // fade out disc at edges
                vec3 localcolor = vec3(0.0, 0.0, 0.0); // density color white->gray
        
                alpha = (1.0-sum.w)*alpha; // alpha/density saturation (the more a cloud layer\\\'s density, the more the higher layers will be hidden)
                sum += vec4(localcolor*alpha, alpha); // sum up weightened color
            }
            }
            float alpha = smoothstep(1.-radius*.5, 1.0, sum.w);
            sum.rgb /= sum.w+0.0001;
            sum.rgb -= 0.2*vec3(0.8, 0.75, 0.7) * pow(sundot,10.0)*alpha;
            sum.rgb += min(glow, 10.0)*0.2*vec3(1.2, 1.2, 1.2) * pow(sundot,5.0)*(1.0-alpha);

            col = mix( col, sum.rgb , sum.w);//*pow(sundot,10.0) );

            // haze
            col = fade*mix(col, vec3(0.3,0.5,.9), 29.0*(pow( sundot, 50.0 )-pow( sundot, 60.0 ))/(2.+9.*abs(rd.y)));

        #if SCREEN_EFFECT == 1
            if (time<2.5)
            {
                // screen effect
                float c = (col.r+col.g+col.b)* .3 * (.6+.3*cos(gl_FragCoord.y*1.2543)) + .1*(noise((xy+time*2.)*294.)*noise((xy-time*3.)*321.));
                c += max(0.,.08*sin(10.*time+xy.y*7.2543));
                // flicker
                col = vec3(c, c, c) * (1.-0.5*pow(noise(vec2(time*99., 0.)), 9.));
            }
            else
            {
                // bam
                float c = clamp(1.-(time-2.5)*6., 0., 1. );
                col = mix(col, vec3(1.,1.,1.),c);
            }
        #endif
            
            // Vignetting
            vec2 xy2 = gl_FragCoord.xy / iResolution.xy;
            col *= vec3(.5, .5, .5) + 0.25*pow(100.0*xy2.x*xy2.y*(1.0-xy2.x)*(1.0-xy2.y), .5 );	

            fragColor = vec4(col,1.0);
        }
        ',
		'https://www.shadertoy.com/view/lty3Rt'
	];
}
