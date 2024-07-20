package com.example.yogi_application.fragment

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.AdapterView
import android.widget.Toast
import androidx.camera.core.Preview
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.core.Camera
import androidx.camera.core.AspectRatio
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.Observer
import androidx.navigation.Navigation
import com.bumptech.glide.Glide
import com.example.yogi_application.PoseLandmarkerHelper
import com.example.yogi_application.MainViewModel
import com.example.yogi_application.R
import com.example.yogi_application.databinding.FragmentCameraBinding
import com.example.yogi_application.model.Exercise
import com.example.yogi_application.model.ExerciseFeedback
import com.example.yogi_application.model.ExerciseLog
import com.example.yogi_application.model.KeyPoint
import com.google.common.flogger.backend.LogData
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.google.mediapipe.tasks.vision.core.RunningMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class CameraFragment : Fragment(), PoseLandmarkerHelper.LandmarkerListener {

    companion object {
        private const val TAG = "Pose Landmarker"
    }

    private var _fragmentCameraBinding: FragmentCameraBinding? = null

    private val fragmentCameraBinding
        get() = _fragmentCameraBinding!!

    private lateinit var poseLandmarkerHelper: PoseLandmarkerHelper
    private val viewModel: MainViewModel by activityViewModels()
    private var preview: Preview? = null
    private var imageAnalyzer: ImageAnalysis? = null
    private var camera: Camera? = null
    private var cameraProvider: ProcessCameraProvider? = null
    private var cameraFacing = CameraSelector.LENS_FACING_FRONT
    private var startTime: Long? = null

    /** Blocking ML operations are performed using this executor */
    private lateinit var backgroundExecutor: ExecutorService

    private var exercise: Exercise? = null
    private var poseKeypoint: List<KeyPoint>? = null

    override fun onResume() {
        super.onResume()
        // Make sure that all permissions are still present, since the
        // user could have removed them while the app was in paused state.
        if (!PermissionsFragment.hasPermissions(requireContext())) {
            Navigation.findNavController(
                requireActivity(), R.id.fragment_container
            ).navigate(R.id.action_camera_to_permissions)
        }


        // Start the PoseLandmarkerHelper again when users come back
        // to the foreground.
        backgroundExecutor.execute {
            if(this::poseLandmarkerHelper.isInitialized) {
                if (poseLandmarkerHelper.isClose()) {
                    poseLandmarkerHelper.setupPoseLandmarker()
                }
            }
        }
    }

    override fun onPause() {
        super.onPause()
        if(this::poseLandmarkerHelper.isInitialized) {
            viewModel.setMinPoseDetectionConfidence(poseLandmarkerHelper.minPoseDetectionConfidence)
            viewModel.setMinPoseTrackingConfidence(poseLandmarkerHelper.minPoseTrackingConfidence)
            viewModel.setMinPosePresenceConfidence(poseLandmarkerHelper.minPosePresenceConfidence)
            viewModel.setDelegate(poseLandmarkerHelper.currentDelegate)

            // Close the PoseLandmarkerHelper and release resources
            backgroundExecutor.execute { poseLandmarkerHelper.clearPoseLandmarker() }
        }
    }

    override fun onDestroyView() {
        _fragmentCameraBinding = null
        super.onDestroyView()

        // Shut down our background executor
        backgroundExecutor.shutdown()
        backgroundExecutor.awaitTermination(
            Long.MAX_VALUE, TimeUnit.NANOSECONDS
        )
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _fragmentCameraBinding =
            FragmentCameraBinding.inflate(inflater, container, false)
        startTime = System.currentTimeMillis()
        val prefs = activity?.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val exerciseString = prefs?.getString("flutter.exercise", "")
        val event = prefs?.getString("flutter.event_id", null)

        exercise = exerciseString?.let { Exercise.fromJson(it) };
        viewModel.exercise = exercise;
        if (exercise?.poses?.size != null) {
            val keypointUrl = exercise?.poses?.get(0)?.pose?.keypointUrl
            loadJsonFromUrl(keypointUrl) { jsonString ->
                if (jsonString != null) {
                    // Example using Gson:
                    val listType = object : TypeToken<List<KeyPoint>>() {}.type
                    poseKeypoint = Gson().fromJson(jsonString, listType)
                    Log.d(TAG, "onCreateView: success $poseKeypoint")
                } else {
                    Log.d(TAG, "onCreateView: error Keypoint")
                }
            }
            Glide.with(this)
                .load(exercise?.poses?.get(0)?.pose?.imageUrl)
                .into(_fragmentCameraBinding!!.imageSample)
        }

        Handler(Looper.getMainLooper()).postDelayed({
            if (_fragmentCameraBinding != null) { // Null check to ensure binding is still valid
                val coverImageSample = _fragmentCameraBinding!!.coverImageSample

                // Ensure the ImageView is visible before applying animation
                if (coverImageSample.isVisible) {
                    val animZoomOut = AnimationUtils.loadAnimation(requireContext(),
                        R.anim.zoom_out)

                    coverImageSample.startAnimation(animZoomOut)
                }
            }
        }, 3000)

        viewModel.eventTrigger.observe(viewLifecycleOwner) { indexValue ->
            if (exercise?.poses?.size!! > indexValue) {
                if (exercise?.poses?.size != null) {
                    val keypointUrl = exercise?.poses?.get(indexValue)?.pose?.keypointUrl
                    loadJsonFromUrl(keypointUrl) { jsonString ->
                        if (jsonString != null) {
                            // Example using Gson:
                            val listType = object : TypeToken<List<KeyPoint>>() {}.type
                            poseKeypoint = Gson().fromJson(jsonString, listType)
                            Log.d(TAG, "onCreateView: success $poseKeypoint")
                        } else {
                            Log.d(TAG, "onCreateView: error Keypoint")
                        }
                    }
                    Glide.with(this)
                        .load(exercise?.poses?.get(indexValue)?.pose?.imageUrl)
                        .into(_fragmentCameraBinding!!.imageSample)
                }
                val coverImageSample = _fragmentCameraBinding!!.coverImageSample
                val animZoomIn = AnimationUtils.loadAnimation(requireContext(),
                    R.anim.zoom_in)

                coverImageSample.startAnimation(animZoomIn)
                Handler(Looper.getMainLooper()).postDelayed({
                    if (_fragmentCameraBinding != null) { // Null check to ensure binding is still valid

                        // Ensure the ImageView is visible before applying animation
                        if (coverImageSample.isVisible) {
                            val animZoomOut = AnimationUtils.loadAnimation(requireContext(),
                                R.anim.zoom_out)

                            coverImageSample.startAnimation(animZoomOut)
                        }
                    }
                }, 10000)
            } else {
                val totalTimeFinish = (System.currentTimeMillis() - startTime!!) / 1000

                val exerciseLog: ExerciseLog = ExerciseLog(exercise?.id!!, 1, exercise?.poses?.size!!, viewModel.getScore(), null, viewModel.poseLogResults, totalTimeFinish.toInt(), event?.toInt())
                // Jump to the main thread to use MethodChannel

                Log.d("NoTag", exerciseLog.toJson());
                Handler(Looper.getMainLooper()).post {
                    MethodChannel(
                        viewModel.flutterEngine?.dartExecutor?.binaryMessenger!!, // Use flutterEngine here
                        "com.example.yogitech"
                    ).invokeMethod("receiveObject", exerciseLog.toJson())
                }
                activity?.finish();
            }
        }
        return fragmentCameraBinding.root
    }

    @SuppressLint("MissingPermission")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.pauseCamera.observe(viewLifecycleOwner, Observer
        { shouldPause ->
            if (shouldPause) {
                onPause()
            } else {
                onResume()
            }
        })
        // Initialize our background executor
        backgroundExecutor = Executors.newSingleThreadExecutor()

        // Wait for the views to be properly laid out
        fragmentCameraBinding.viewFinder.post {
            // Set up the camera and its use cases
            setUpCamera()

        }

        // Create the PoseLandmarkerHelper that will handle the inference
        backgroundExecutor.execute {
            poseLandmarkerHelper = PoseLandmarkerHelper(
                context = requireContext(),
                runningMode = RunningMode.LIVE_STREAM,
                minPoseDetectionConfidence = viewModel.currentMinPoseDetectionConfidence,
                minPoseTrackingConfidence = viewModel.currentMinPoseTrackingConfidence,
                minPosePresenceConfidence = viewModel.currentMinPosePresenceConfidence,
                currentDelegate = viewModel.currentDelegate,
                poseLandmarkerHelperListener = this
            )
        }
    }

    // Initialize CameraX, and prepare to bind the camera use cases
    private fun setUpCamera() {
        val cameraProviderFuture =
            ProcessCameraProvider.getInstance(requireContext())
        cameraProviderFuture.addListener(
            {
                // CameraProvider
                cameraProvider = cameraProviderFuture.get()

                // Build and bind the camera use cases
                bindCameraUseCases()
            }, ContextCompat.getMainExecutor(requireContext())
        )
    }

    // Declare and bind preview, capture and analysis use cases
    @SuppressLint("UnsafeOptInUsageError")
    private fun bindCameraUseCases() {

        // CameraProvider
        val cameraProvider = cameraProvider
            ?: throw IllegalStateException("Camera initialization failed.")

        val cameraSelector =
            CameraSelector.Builder().requireLensFacing(cameraFacing).build()

        // Preview. Only using the 4:3 ratio because this is the closest to our models
        preview = Preview.Builder().setTargetAspectRatio(AspectRatio.RATIO_4_3)
            .setTargetRotation(fragmentCameraBinding.viewFinder.display.rotation)
            .build()

        // ImageAnalysis. Using RGBA 8888 to match how our models work
        imageAnalyzer =
            ImageAnalysis.Builder().setTargetAspectRatio(AspectRatio.RATIO_4_3)
                .setTargetRotation(fragmentCameraBinding.viewFinder.display.rotation)
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .build()
                // The analyzer can then be assigned to the instance
                .also {
                    it.setAnalyzer(backgroundExecutor) { image ->
                        detectPose(image)
                    }
                }

        // Must unbind the use-cases before rebinding them
        cameraProvider.unbindAll()

        try {
            // A variable number of use-cases can be passed here -
            // camera provides access to CameraControl & CameraInfo
            camera = cameraProvider.bindToLifecycle(
                this, cameraSelector, preview, imageAnalyzer
            )

            // Attach the viewfinder's surface provider to preview use case
            preview?.setSurfaceProvider(fragmentCameraBinding.viewFinder.surfaceProvider)
        } catch (exc: Exception) {
            Log.e(TAG, "Use case binding failed", exc)
        }
    }

    private fun detectPose(imageProxy: ImageProxy) {
        if(this::poseLandmarkerHelper.isInitialized) {
            poseLandmarkerHelper.detectLiveStream(
                imageProxy = imageProxy,
                isFrontCamera = cameraFacing == CameraSelector.LENS_FACING_FRONT
            )
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        imageAnalyzer?.targetRotation =
            fragmentCameraBinding.viewFinder.display.rotation
    }

    // Update UI after pose have been detected. Extracts original
    // image height/width to scale and place the landmarks properly through
    // OverlayView
    override fun  onResults(
        resultBundle: PoseLandmarkerHelper.ResultBundle
    ) {
        activity?.runOnUiThread {
            if (_fragmentCameraBinding != null) {

                // Pass necessary information to OverlayView for drawing on the canvas
                fragmentCameraBinding.overlay.setResults(
                    resultBundle.results.first(),
                    resultBundle.inputImageHeight,
                    resultBundle.inputImageWidth,
                    RunningMode.LIVE_STREAM
                )
                val predictKeypoint: MutableList<KeyPoint> = mutableListOf<KeyPoint>()
                if (resultBundle.results.first().landmarks().size > 0) {
                    for (normalizedLandmark in resultBundle.results.first().landmarks().get(0)) {
                        predictKeypoint.add(
                            KeyPoint(
                                normalizedLandmark.x(),
                                normalizedLandmark.y(),
                                normalizedLandmark.y(),
                                normalizedLandmark.visibility().get()
                            )
                        )
                    }
                    val exerciseFeedback = ExerciseFeedback(poseKeypoint, predictKeypoint)
                    viewModel.postExerciseFeedback(exerciseFeedback)
                }
                // Force a redraw
                fragmentCameraBinding.overlay.invalidate()
            }
        }
    }

    override fun onError(error: String, errorCode: Int) {
        activity?.runOnUiThread {
            Toast.makeText(requireContext(), error, Toast.LENGTH_SHORT).show()
        }
    }

    fun loadJsonFromUrl(url: String?, callback: (String?) -> Unit) {
        val client = OkHttpClient()
        if (url != null) {
            val request = Request.Builder()
                .url(url)
                .build()

            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val response = client.newCall(request).execute()
                    val jsonString = response.body?.string()

                    withContext(Dispatchers.Main) {
                        callback(jsonString)
                    }
                } catch (e: Exception) {
                    Log.e("loadJsonFromUrl", "Error fetching JSON: ${e.message}")
                    withContext(Dispatchers.Main) {
                        callback(null) // Notify about the error
                    }
                }
            }
        }
    }
}
