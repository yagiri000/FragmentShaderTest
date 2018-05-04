using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCube : MonoBehaviour {

    [SerializeField]
    private LayerMask mask;

    private Transform _transform = null;
    private Transform CashedTransform {
        get {
            if ( _transform == null ) {
                _transform = GetComponent<Transform>();
            }
            return _transform;
        }
    }

    // Use this for initialization
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        if ( Input.GetMouseButton( 0 ) ) {
            Move( Input.mousePosition );
        }

        if ( Input.touchCount > 0 ) {
            Touch touch = Input.GetTouch( 0 );
            if ( touch.phase == TouchPhase.Began ) {
                // タッチ開始
                Move( Input.touches[0].position );
            }
            else if ( touch.phase == TouchPhase.Moved ) {
                // タッチ移動
            }
            else if ( touch.phase == TouchPhase.Ended ) {
                // タッチ終了
            }
        }
    }

    void Move( Vector3 pos ) {

        Ray ray = Camera.main.ScreenPointToRay( pos );
        RaycastHit hit;
        if ( Physics.Raycast( ray, out hit, 100, mask ) ) {
            CashedTransform.position = hit.point;
        }
    }
}
