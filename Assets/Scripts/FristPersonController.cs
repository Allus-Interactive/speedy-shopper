using UnityEngine;

public class FristPersonController : MonoBehaviour
{
    public float speed = 5f;
    public float mouseSensitivity = 2f;
    public Transform playerCamera;

    private float cameraPitch = 0f;
    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        // Hide cursor and lock it to center
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {
        LookAround();

        // Allow player to unlock the cursor by pressing Escape
        // TODO: use in conjunction with a UI menu
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }

    void FixedUpdate()
    {
        Move();
    }

    void LookAround()
    {
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        // Rotate the player horizontally
        transform.Rotate(Vector3.up * mouseX);

        // Rotate the camera vertically
        cameraPitch -= mouseY;
        cameraPitch = Mathf.Clamp(cameraPitch, -90f, 90f); // clamping the pitch prevents flipping
        playerCamera.localEulerAngles = Vector3.right * cameraPitch;
    }

    void Move()
    {
        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");

        Vector3 move = transform.right * x + transform.forward * z;
        rb.MovePosition(rb.position + move * speed * Time.fixedDeltaTime);
    }
}
