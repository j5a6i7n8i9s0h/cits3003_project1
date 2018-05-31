//varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 pos;

uniform float texScale;
uniform sampler2D texture;
uniform vec3 AmbientProduct1, DiffuseProduct1, SpecularProduct1;
uniform vec3 AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform vec4 LightPosition2;
uniform float Shininess;

uniform vec3 randoms;
uniform float time;
uniform int ColourEffect;

varying vec3 fN;
varying vec3 fE;
varying vec3 fL1;
varying vec3 fL2;

vec3 secondlight(){
    vec3 N = normalize(fN);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL2);

    vec3 H = normalize(L+E);

    vec3 Lvec = LightPosition2.xyz;
    float distance = length(Lvec);
     
    vec3 ambient = AmbientProduct2;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct2;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct2;

    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } // discard the specular if its behind the light

    return (ambient + diffuse + specular);
}

void main()
{
    vec3 N = normalize(fN);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL1);

    vec3 H = normalize(L+E);

    vec3 Lvec = LightPosition.xyz - pos;
    float distance = length(Lvec);
    float lightRadius =5.0; 
    float distanceFactor = 1.0 - dot(Lvec/lightRadius, Lvec/lightRadius);
    distanceFactor = max(0.0, distanceFactor); //i think i include global abient in here soon so it doesnt drain light when it gets antibright

    vec3 ambient = AmbientProduct1;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct1* distanceFactor;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct1 * distanceFactor;

    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } // discard the specular if its behind the light

    vec3 globalAmbient = vec3(0.03, 0.03, 0.03);
    vec3 light1 = ambient + diffuse + specular;
    vec3 light2 = secondlight();
    vec4 color;

    if(ColourEffect == 90){
      color.rgb = vec3(randoms[0], randoms[1], randoms[2]) + globalAmbient  + light1 + light2;
      color.a = 1.0;
      gl_FragColor = color * texture2D( texture, texCoord * texScale );
    }else{
      color.rgb = globalAmbient  + light1 + light2;
      color.a = 1.0;
      gl_FragColor = color * texture2D( texture, texCoord * texScale );
    }
    //color.rgb = globalAmbient  + ambient + diffuse + specular;

}

