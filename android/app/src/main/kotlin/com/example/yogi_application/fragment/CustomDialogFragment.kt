package com.example.yogi_application.fragment
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.activityViewModels
import com.example.yogi_application.MainViewModel
import com.example.yogi_application.databinding.DialogCustomBinding

class CustomDialogFragment : DialogFragment() {

    private var _binding: DialogCustomBinding? = null
    private val binding get() = _binding!!
    private val viewModel: MainViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding = DialogCustomBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.btnResume.setOnClickListener {
            // Handle resume action
            dismiss()  // Close the dialog
            viewModel.pauseCamera.value = false
        }

        binding.btnExit.setOnClickListener {
            // Handle exit action
            activity?.finish()  // Close the activity
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}