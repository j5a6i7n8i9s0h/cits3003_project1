attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

attribute vec4 boneIDs;
attribute vec4 boneWeights;
uniform mat4 boneTransforms[64];

varying vec2 texCoord;
//varying vec4  r;
varying vec3 pos;

//uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform vec4 LightPosition2;
uniform float Shininess;

uniform bool RippleEffect;
uniform float time;

varying vec3 fN;
varying vec3 fE;
varying vec3 fL1;
varying vec3 fL2;


void main()
{

    mat4 boneTransform = boneWeights[0] * boneTransforms[int(boneIDs[0])] +
                         boneWeights[1] * boneTransforms[int(boneIDs[1])] +
                         boneWeights[2] * boneTransforms[int(boneIDs[2])] +
                         boneWeights[3] * boneTransforms[int(boneIDs[3])];

    vec4 vpos = vec4(vPosition, 1.0);
    vpos = boneTransform*vpos;
    vec4 vnorm = boneTransform*vec4(vNormal,0.0);
    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;

    if(RippleEffect){
        vpos.z = vpos.z + (sin(time*vpos.x)*0.02);
    }
    // The vector to the light from the vertex
   /*
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
    //fN = (ModelView*vec4(vNormal,0.0)).xyz;
    fN = (ModelView*vnorm).xyz;
    fE = -(ModelView*vpos).xyz;
    fL1 = LightPosition.xyz - (ModelView*vpos).xyz;
    fL2 = LightPosition2.xyz - (ModelView*vpos).xyz;
    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
