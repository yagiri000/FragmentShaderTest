using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SolverChanger : MonoBehaviour {

    [SerializeField]
    private List<Material> solvers;


    private int index = 0;
    private MeshRenderer m_meshRenderer;

	// Use this for initialization
	void Start () {
        m_meshRenderer = GetComponent<MeshRenderer>();
	}
	
	// Update is called once per frame
	void Update () {
        if ( Input.GetKeyDown( KeyCode.RightArrow ) ) {
            index++;
            if(index > solvers.Count - 1 ) {
                index = solvers.Count - 1;
            }
            m_meshRenderer.material = solvers[index];
        }

        if ( Input.GetKeyDown( KeyCode.LeftArrow ) ) {
            index--;
            if ( index < 0 ) {
                index = 0;
            }
            m_meshRenderer.material = solvers[index];
        }
    }
}
