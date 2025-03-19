package com.yogitech.yogi_application.fragment
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.activityViewModels
import androidx.transition.Visibility
import com.yogitech.yogi_application.MainViewModel
import com.yogitech.yogi_application.R
import com.yogitech.yogi_application.databinding.DialogCustomBinding
import com.yogitech.yogi_application.model.PoseLogResult

class CustomDialogFragment : DialogFragment() {

    private var _binding: DialogCustomBinding? = null
    private val binding get() = _binding!!
    private val viewModel: MainViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val prefs = activity?.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val allowSkip = prefs?.getBoolean("flutter.allowSkip", false)

        _binding = DialogCustomBinding.inflate(inflater, container, false)
        if (allowSkip == false) {
            _binding?.btnSkip?.visibility = View.GONE;
        }
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.btnResume.setOnClickListener {
            // Handle resume action
            dismiss()  // Close the dialog
            viewModel.pauseCamera.value = false

        }

        binding.btnSkip.setOnClickListener {
            dismiss()
            val currentIndex = viewModel.currentIndex
            if (currentIndex < viewModel.exercise?.poses?.size!!) {
                val second = 1
                val poseLogResult: PoseLogResult = PoseLogResult(
                    viewModel.exercise?.poses?.get(currentIndex)?.pose?.id!!,
                    0.toFloat() , second
                )

                viewModel.poseLogResults.add(poseLogResult)
            }
            viewModel.pauseCamera.value = false
            viewModel.triggerEvent();
        }

        binding.btnExit.setOnClickListener {
            // Handle exit action
            activity?.finish()  // Close the activity
        }

    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = super.onCreateDialog(savedInstanceState)
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false);
        dialog.setOnCancelListener {
            dismiss()
            viewModel.pauseCamera.value = false
        }
        return dialog
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}