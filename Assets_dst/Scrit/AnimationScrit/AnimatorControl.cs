using System;
using UnityEngine;

public class AnimatorControl : MonoBehaviour
{
    private Animator animator;

    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void AnimatorChangeFinished()
    {
        animator.SetBool("Change",false);
    }
}
