varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 pos;

uniform float texScale;
uniform sampler2D texture;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition,LightPosition2;
uniform float Shininess;

//uniform float LightBrightness, LightBrightness2;


varying vec3 fN;
varying vec3 fL,fL2;
varying vec3 fE;


void main()
{
    vec3 N = normalize(fN);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL);

    vec3 L2 = normalize(fL2);


    vec3 H = normalize(L+E);
    
    // Light source 2 
    vec3 H2 = normalize(L2 + E);


    vec3 Lvec = LightPosition.xyz - pos;
    float distance = length(Lvec);
    float lightRadius =5.0; //want to make this variable depeding on strenth of the light
    float distanceFactor = 1.0 - dot(Lvec/lightRadius, Lvec/lightRadius);
    distanceFactor = max(0.0, distanceFactor); //i think i include global abient in here soon so it doesnt drain light when it gets antibright

    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct* distanceFactor;

    float Kd2 = max( dot(L2,N),0.0);
    

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    float Ks2 =pow( max(dot(N, H2), 0.0), Shininess );

    vec3  specular = Ks * SpecularProduct * distanceFactor;

    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } // discard the specular if its behind the light

    if (dot(L2, N) < 0.0 ) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }
    vec3 globalAmbient = vec3(0.03, 0.03, 0.03);

    vec4 color;
    color.rgb = globalAmbient  + ambient + diffuse + specular;
    color.a = 1.0;
    gl_FragColor = color * texture2D( texture, texCoord * texScale );
}
