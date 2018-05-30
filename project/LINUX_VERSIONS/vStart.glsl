attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;
varying vec3 pos;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition,LightPosition2;
uniform float Shininess;

uniform vec3 LightColor, LightColor2;
//uniform float LightBrightness, LightBrightness2;

uniform bool RippleEffect;
uniform float time;

varying vec3 fN;
varying vec3 fE;
varying vec3 fL,fL2;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;

    if(RippleEffect){
        vpos.z = vpos.z + (sin(time*vpos.x)*0.02);
    }
    /*
        // The vector to the light from the vertex
        /// WHY DID YOU COMMENT THIS    - J
        vec3 Lvec = LightPosition.xyz - pos;

        float distance = length(Lvec);
        float lightRadius =5.0;
        float distanceFactor = 1.0 - dot(Lvec/lightRadius, Lvec/lightRadius);
        distanceFactor = max(0.0, distanceFactor);

        // Unit direction vectors for Blinn-Phong shading calculation
        vec3 L = normalize( Lvec );   // Direction to the light source
        vec3 E = normalize( -pos );   // Direction to the eye/camera
        vec3 H = normalize( L + E );  // Halfway vector

        // Transform vertex normal into eye coordinates (assumes scaling
        // is uniform across dimensions)
        vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

        // Compute terms in the illumination equation
        vec3 ambient = AmbientProduct*distanceFactor;


        float Kd = max( dot(L, N), 0.0 );
        vec3  diffuse = Kd*DiffuseProduct* distanceFactor;

        float Ks = pow( max(dot(N, H), 0.0), Shininess );
        vec3  specular = Ks * SpecularProduct * distanceFactor;

        if (dot(L, N) < 0.0 ) {
    	specular = vec3(0.0, 0.0, 0.0);
        }

        // globalAmbient is independent of distance from the light source
        vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
        color.rgb = globalAmbient  + ambient + diffuse + specular;
        color.a = 1.0;
    */
    fN = (ModelView*vec4(vNormal,0.0)).xyz;
    fE = -(ModelView*vpos).xyz;

    fL = LightPosition.xyz -pos;
    //second light source stuff 
    fL2 = LightPosition2.xyz - pos;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
