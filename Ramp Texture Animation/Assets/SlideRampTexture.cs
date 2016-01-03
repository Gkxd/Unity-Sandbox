using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Renderer))]
public class SlideRampTexture : MonoBehaviour {

    public float speed;

    private Material m;
    void Start() {
        m = GetComponent<Renderer>().material;
    }

    void Update() {
        Vector2 offset = new Vector2(-Time.time * speed % 1, 0);
        m.SetTextureOffset("_MainTex", offset);
    }
}
