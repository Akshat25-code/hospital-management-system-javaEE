<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Video Call - Patient Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../style.css">
    <style>
        .video-container {
            background: #000;
            border-radius: 12px;
            position: relative;
            overflow: hidden;
        }
        .call-waiting {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
            border-radius: 12px;
        }
        .call-controls {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
        }
        .btn-control {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 0 5px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .connection-indicator {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 10;
        }
        .call-info-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="../dashboard.jsp">
                <i class="fas fa-hospital me-2"></i>Hospital Management
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="../dashboard.jsp">
                    <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Main Video Area -->
            <div class="col-lg-8 mb-4">
                <div class="card call-info-card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-video me-2"></i>Video Consultation
                        </h5>
                        <div>
                            <span id="callTimer" class="badge bg-light text-dark me-2">00:00</span>
                            <span id="connectionStatus" class="badge bg-warning">Waiting to Join</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="video-container" style="height: 500px; position: relative;">
                            <!-- Remote Video (Doctor) -->
                            <video id="remoteVideo" class="w-100 h-100" style="object-fit: cover;" autoplay playsinline></video>
                            
                            <!-- Local Video (Patient - small overlay) -->
                            <video id="localVideo" 
                                   style="position: absolute; top: 15px; right: 15px; width: 160px; height: 120px; 
                                          border-radius: 8px; border: 3px solid white; object-fit: cover;" 
                                   autoplay muted playsinline></video>
                            
                            <!-- Connection Status -->
                            <div class="connection-indicator">
                                <span id="connectionIndicator" class="badge bg-warning">
                                    <i class="fas fa-circle me-1"></i>Connecting...
                                </span>
                            </div>
                            
                            <!-- Call Controls -->
                            <div class="call-controls">
                                <button id="muteBtn" class="btn btn-secondary btn-control" onclick="toggleMute()" title="Mute/Unmute">
                                    <i class="fas fa-microphone"></i>
                                </button>
                                <button id="videoBtn" class="btn btn-secondary btn-control" onclick="toggleVideo()" title="Video On/Off">
                                    <i class="fas fa-video"></i>
                                </button>
                                <button class="btn btn-danger btn-control" onclick="endCall()" title="End Call">
                                    <i class="fas fa-phone-slash"></i>
                                </button>
                            </div>
                            
                            <!-- Waiting Screen -->
                            <div id="waitingScreen" class="call-waiting position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center">
                                <div>
                                    <i class="fas fa-video fa-4x mb-3"></i>
                                    <h3>Joining Video Call...</h3>
                                    <p class="mb-4">Please wait while we connect you to your doctor</p>
                                    <div class="spinner-border" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Call Information Sidebar -->
            <div class="col-lg-4">
                <!-- Doctor Information -->
                <div class="card call-info-card mb-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0"><i class="fas fa-user-md me-2"></i>Doctor Information</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="avatar-circle bg-primary text-white me-3" style="width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Dr. ${doctor.firstName} ${doctor.lastName}</h6>
                                <small class="text-muted">${doctor.specialization}</small>
                            </div>
                        </div>
                        <div class="row text-center">
                            <div class="col-6">
                                <small class="text-muted">Experience</small>
                                <div class="fw-bold">8+ Years</div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Rating</small>
                                <div class="fw-bold">4.8 ⭐</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointment Details -->
                <div class="card call-info-card mb-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0"><i class="fas fa-calendar me-2"></i>Appointment Details</h6>
                    </div>
                    <div class="card-body">
                        <p><strong>Date:</strong> <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy"/></p>
                        <p><strong>Time:</strong> <fmt:formatDate value="${appointment.appointmentTime}" pattern="hh:mm a"/></p>
                        <p><strong>Type:</strong> Video Consultation</p>
                        <p><strong>Duration:</strong> 30 minutes</p>
                        <p><strong>Reason:</strong> ${appointment.reason}</p>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card call-info-card">
                    <div class="card-header bg-light">
                        <h6 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h6>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-outline-primary btn-sm w-100 mb-2" onclick="requestPrescription()">
                            <i class="fas fa-prescription me-2"></i>Request Prescription
                        </button>
                        <button class="btn btn-outline-info btn-sm w-100 mb-2" onclick="scheduleFollowUp()">
                            <i class="fas fa-calendar-plus me-2"></i>Schedule Follow-up
                        </button>
                        <button class="btn btn-outline-secondary btn-sm w-100" onclick="downloadReport()">
                            <i class="fas fa-download me-2"></i>Download Report
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Call Feedback Modal -->
    <div class="modal fade" id="feedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Rate Your Consultation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <div class="rating">
                            <i class="fas fa-star rating-star" data-rating="1"></i>
                            <i class="fas fa-star rating-star" data-rating="2"></i>
                            <i class="fas fa-star rating-star" data-rating="3"></i>
                            <i class="fas fa-star rating-star" data-rating="4"></i>
                            <i class="fas fa-star rating-star" data-rating="5"></i>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Additional Comments</label>
                        <textarea class="form-control" id="feedbackComments" rows="3" placeholder="Share your experience..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Skip</button>
                    <button type="button" class="btn btn-primary" onclick="submitFeedback()">Submit Feedback</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // WebRTC Implementation for Patient
        let localStream = null;
        let remoteStream = null;
        let peerConnection = null;
        let isAudioMuted = false;
        let isVideoMuted = false;

        // WebRTC configuration
        const configuration = {
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' }
            ]
        };

        // Initialize WebRTC when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializePatientCall();
            startCallTimer();
        });

        async function initializePatientCall() {
            try {
                // Get user media
                localStream = await navigator.mediaDevices.getUserMedia({
                    video: { width: 1280, height: 720 },
                    audio: true
                });
                
                // Display local video
                const localVideo = document.getElementById('localVideo');
                if (localVideo) {
                    localVideo.srcObject = localStream;
                }
                
                // Create peer connection
                peerConnection = new RTCPeerConnection(configuration);
                
                // Add local stream
                localStream.getTracks().forEach(track => {
                    peerConnection.addTrack(track, localStream);
                });
                
                // Handle remote stream
                peerConnection.ontrack = (event) => {
                    remoteStream = event.streams[0];
                    const remoteVideo = document.getElementById('remoteVideo');
                    if (remoteVideo) {
                        remoteVideo.srcObject = remoteStream;
                    }
                    // Hide waiting screen
                    document.getElementById('waitingScreen').style.display = 'none';
                };
                
                // Handle connection state
                peerConnection.onconnectionstatechange = () => {
                    updateConnectionStatus(peerConnection.connectionState);
                };
                
                // Simulate doctor joining (for demo)
                setTimeout(() => {
                    simulateDoctorJoin();
                }, 3000);
                
            } catch (error) {
                console.error('Error accessing camera/microphone:', error);
                showCameraError();
            }
        }

        async function simulateDoctorJoin() {
            try {
                // Simulate doctor connection
                updateConnectionStatus('connected');
                document.getElementById('waitingScreen').style.display = 'none';
                
                // For demo: show placeholder in remote video
                const remoteVideo = document.getElementById('remoteVideo');
                const canvas = document.createElement('canvas');
                canvas.width = 640;
                canvas.height = 480;
                const ctx = canvas.getContext('2d');
                
                // Draw placeholder
                ctx.fillStyle = '#4a90e2';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.fillStyle = 'white';
                ctx.font = '24px Arial';
                ctx.textAlign = 'center';
                ctx.fillText('Dr. Smith', canvas.width/2, canvas.height/2 - 20);
                ctx.fillText('Connected', canvas.width/2, canvas.height/2 + 20);
                
                const stream = canvas.captureStream();
                remoteVideo.srcObject = stream;
                
            } catch (error) {
                console.error('Error in doctor simulation:', error);
            }
        }

        function toggleMute() {
            if (localStream) {
                const audioTrack = localStream.getAudioTracks()[0];
                if (audioTrack) {
                    audioTrack.enabled = !audioTrack.enabled;
                    isAudioMuted = !audioTrack.enabled;
                    
                    const muteBtn = document.getElementById('muteBtn');
                    const icon = muteBtn.querySelector('i');
                    
                    if (isAudioMuted) {
                        icon.className = 'fas fa-microphone-slash';
                        muteBtn.classList.add('btn-danger');
                        muteBtn.classList.remove('btn-secondary');
                    } else {
                        icon.className = 'fas fa-microphone';
                        muteBtn.classList.remove('btn-danger');
                        muteBtn.classList.add('btn-secondary');
                    }
                }
            }
        }

        function toggleVideo() {
            if (localStream) {
                const videoTrack = localStream.getVideoTracks()[0];
                if (videoTrack) {
                    videoTrack.enabled = !videoTrack.enabled;
                    isVideoMuted = !videoTrack.enabled;
                    
                    const videoBtn = document.getElementById('videoBtn');
                    const icon = videoBtn.querySelector('i');
                    
                    if (isVideoMuted) {
                        icon.className = 'fas fa-video-slash';
                        videoBtn.classList.add('btn-danger');
                        videoBtn.classList.remove('btn-secondary');
                    } else {
                        icon.className = 'fas fa-video';
                        videoBtn.classList.remove('btn-danger');
                        videoBtn.classList.add('btn-secondary');
                    }
                }
            }
        }

        function endCall() {
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
            }
            if (peerConnection) {
                peerConnection.close();
            }
            
            // Show feedback modal
            const feedbackModal = new bootstrap.Modal(document.getElementById('feedbackModal'));
            feedbackModal.show();
        }

        function updateConnectionStatus(state) {
            const statusElement = document.getElementById('connectionStatus');
            const indicatorElement = document.getElementById('connectionIndicator');
            
            switch (state) {
                case 'connected':
                    statusElement.innerHTML = 'Connected';
                    statusElement.className = 'badge bg-success';
                    indicatorElement.innerHTML = '<i class="fas fa-circle me-1"></i>Connected';
                    indicatorElement.className = 'badge bg-success';
                    break;
                case 'connecting':
                    statusElement.innerHTML = 'Connecting...';
                    statusElement.className = 'badge bg-warning';
                    indicatorElement.innerHTML = '<i class="fas fa-circle me-1"></i>Connecting...';
                    indicatorElement.className = 'badge bg-warning';
                    break;
                case 'failed':
                    statusElement.innerHTML = 'Connection Failed';
                    statusElement.className = 'badge bg-danger';
                    indicatorElement.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i>Failed';
                    indicatorElement.className = 'badge bg-danger';
                    break;
            }
        }

        function showCameraError() {
            const waitingScreen = document.getElementById('waitingScreen');
            waitingScreen.innerHTML = `
                <div class="text-center">
                    <i class="fas fa-exclamation-triangle fa-4x mb-3 text-warning"></i>
                    <h3>Camera Access Required</h3>
                    <p>Please allow camera and microphone access for video calling</p>
                    <button class="btn btn-outline-light" onclick="location.reload()">Try Again</button>
                </div>
            `;
        }

        // Call timer
        let callStartTime = new Date();
        function startCallTimer() {
            setInterval(() => {
                const now = new Date();
                const elapsed = Math.floor((now - callStartTime) / 1000);
                const minutes = Math.floor(elapsed / 60);
                const seconds = elapsed % 60;
                
                const timerElement = document.getElementById('callTimer');
                if (timerElement) {
                    timerElement.textContent = 
                        `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
                }
            }, 1000);
        }

        // Quick actions
        function requestPrescription() {
            alert('Prescription request sent to doctor');
        }

        function scheduleFollowUp() {
            alert('Follow-up scheduling feature would open here');
        }

        function downloadReport() {
            alert('Report download feature would be implemented here');
        }

        // Feedback system
        let selectedRating = 0;

        document.querySelectorAll('.rating-star').forEach(star => {
            star.addEventListener('click', function() {
                selectedRating = parseInt(this.dataset.rating);
                updateStarRating(selectedRating);
            });
        });

        function updateStarRating(rating) {
            document.querySelectorAll('.rating-star').forEach((star, index) => {
                if (index < rating) {
                    star.style.color = '#ffc107';
                } else {
                    star.style.color = '#dee2e6';
                }
            });
        }

        function submitFeedback() {
            const comments = document.getElementById('feedbackComments').value;
            
            // In real implementation, send to server
            console.log('Feedback:', { rating: selectedRating, comments });
            
            const feedbackModal = bootstrap.Modal.getInstance(document.getElementById('feedbackModal'));
            feedbackModal.hide();
            
            // Redirect to dashboard
            setTimeout(() => {
                window.location.href = '../dashboard.jsp';
            }, 500);
        }
    </script>
</body>
</html>





