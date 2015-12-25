using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Rigidbody))]
public class PlayerJump : MonoBehaviour {

    public float gravity;
    public float jumpForce;
    public float jumpSpeed;

    private new Rigidbody rigidbody;

    void Start() {
        rigidbody = GetComponent<Rigidbody>();
    }

    void FixedUpdate() {
        if (Input.GetKey(KeyCode.Space)) {
            rigidbody.AddForce(Vector3.up * jumpForce);
        }

        rigidbody.AddForce(Vector3.down * gravity);
    }

    void Update() {
        if (Input.GetKeyDown(KeyCode.Space)) {
            rigidbody.velocity += Vector3.up * jumpSpeed;
        }
    }
}