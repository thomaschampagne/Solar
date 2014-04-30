Shader "Solar/PlanetDefault"
{
	Properties 
	{
_DiffuseTexture("_DiffuseTexture", 2D) = "black" {}
_DiffuseTextureMix("_DiffuseTextureMix", 2D) = "black" {}
_DiffuseColor("_DiffuseColor", Color) = (1,1,1,1)
_NormalTexture("_NormalTexture", 2D) = "black" {}
_SpecularTexture("_SpecularTexture", 2D) = "black" {}
_RimColor("_RimColor", Color) = (0,0.1188812,1,1)
_RimPower("_RimPower", Range(0.1,7) ) = 1.707772
_Glossiness("_Glossiness", Range(-3,3) ) = 0.4300518
_SpecularColor("_SpecularColor", Color) = (0.3006994,1,0,1)

	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Geometry"
"IgnoreProjector"="False"
"RenderType"="Opaque"

		}

		
Cull Back
ZWrite On
ZTest LEqual
ColorMask RGBA
Fog{
}


		CGPROGRAM
#pragma surface surf BlinnPhongEditor  vertex:vert
#pragma target 2.0


sampler2D _DiffuseTexture;
sampler2D _DiffuseTextureMix;
float4 _DiffuseColor;
sampler2D _NormalTexture;
sampler2D _SpecularTexture;
float4 _RimColor;
float _RimPower;
float _Glossiness;
float4 _SpecularColor;

			struct EditorSurfaceOutput {
				half3 Albedo;
				half3 Normal;
				half3 Emission;
				half3 Gloss;
				half Specular;
				half Alpha;
				half4 Custom;
			};
			
			inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
			{
half3 spec = light.a * s.Gloss;
half4 c;
c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
c.a = s.Alpha;
return c;

			}

			inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
			{
				half3 h = normalize (lightDir + viewDir);
				
				half diff = max (0, dot ( lightDir, s.Normal ));
				
				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, s.Specular*128.0);
				
				half4 res;
				res.rgb = _LightColor0.rgb * diff;
				res.w = spec * Luminance (_LightColor0.rgb);
				res *= atten * 2.0;

				return LightingBlinnPhongEditor_PrePass( s, res );
			}
			
			struct Input {
				float2 uv_DiffuseTexture;
float2 uv_DiffuseTextureMix;
float2 uv_NormalTexture;
float3 viewDir;

			};

			void vert (inout appdata_full v, out Input o) {
float4 VertexOutputMaster0_0_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_1_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_2_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_3_NoInput = float4(0,0,0,0);


			}
			

			void surf (Input IN, inout EditorSurfaceOutput o) {
				o.Normal = float3(0.0,0.0,1.0);
				o.Alpha = 1.0;
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Gloss = 0.0;
				o.Specular = 0.0;
				o.Custom = 0.0;
				
float4 Tex2D0=tex2D(_DiffuseTexture,(IN.uv_DiffuseTexture.xyxy).xy);
float4 Tex2D4=tex2D(_DiffuseTextureMix,(IN.uv_DiffuseTextureMix.xyxy).xy);
float4 Lerp0=lerp(Tex2D4,_DiffuseColor,Tex2D4.aaaa);
float4 Add0=Tex2D0 + Lerp0;
float4 Tex2D2=tex2D(_NormalTexture,(IN.uv_NormalTexture.xyxy).xy);
float4 UnpackNormal0=float4(UnpackNormal(Tex2D2).xyz, 1.0);
float4 Fresnel0_1_NoInput = float4(0,0,1,1);
float4 Fresnel0=(1.0 - dot( normalize( float4( IN.viewDir.x, IN.viewDir.y,IN.viewDir.z,1.0 ).xyz), normalize( Fresnel0_1_NoInput.xyz ) )).xxxx;
float4 Pow0=pow(Fresnel0,_RimPower.xxxx);
float4 Multiply0=_RimColor * Pow0;
float4 Tex2D1=tex2D(_DiffuseTexture,(IN.uv_DiffuseTexture.xyxy).xy);
float4 Multiply1=Tex2D1 * _SpecularColor;
float4 Master0_5_NoInput = float4(1,1,1,1);
float4 Master0_7_NoInput = float4(0,0,0,0);
float4 Master0_6_NoInput = float4(1,1,1,1);
o.Albedo = Add0;
o.Normal = UnpackNormal0;
o.Emission = Multiply0;
o.Specular = _Glossiness.xxxx;
o.Gloss = Multiply1;

				o.Normal = normalize(o.Normal);
			}
		ENDCG
	}
	Fallback "Diffuse"
}