Shader "InterestingShader/GravityDeformation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_GravitySourcePos("GravitySourcePos", Vector) = (0, 0, 0, 0)
		_GravityStrength("GravityStrength", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float3 _GravitySourcePos;
			fixed _GravityStrength;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				//构造顶点到pos 的向量Vm
				float3 Vm = _GravitySourcePos - o.vertex;
				//求顶点法线与向量Vm 的点积dotnv
				float dotnv = dot(v.normal, Vm);//saturate(dot(v.normal, Vm));
				//将顶点向Vm 方向移动dotnv 距离
				o.vertex = o.vertex + _GravityStrength * float4(dotnv * normalize(Vm), 0);

				o.vertex = mul(UNITY_MATRIX_VP, o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
