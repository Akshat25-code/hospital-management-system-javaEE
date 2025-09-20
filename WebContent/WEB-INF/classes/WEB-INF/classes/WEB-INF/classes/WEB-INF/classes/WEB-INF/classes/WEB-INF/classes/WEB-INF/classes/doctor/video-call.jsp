<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.VideoCall" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equals("doctor")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Telemedicine Video Call</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .call-card {
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        .call-card.ongoing { border-left-color: #198754; }
        .call-card.completed { border-left-color: #6c757d; }
        .call-card.cancelled { border-left-color: #dc3545; }
        .video-placeholder {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            border-radius: 8px;
        }
        .call-controls {
            background: rgba(0,0,0,0.8);
            border-radius: 50px;
            padding: 10px 20px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="fas fa-video me-2"></i>Telemedicine Video Call</h2>
                    <p class="text-muted">Start a video call with a patient from the appointment page.</p>
                </div>
                <a href="../dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Quick Start Call -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-play me-2"></i>Quick Start Video Call</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="video-call" class="row g-3">
                        <input type="hidden" name="action" value="start">
                        <div class="col-md-4">
                            <label class="form-label">Patient ID</label>
                            <input type="number" class="form-control" name="patientId" required placeholder="Enter Patient ID">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Appointment ID (Optional)</label>
                            <input type="number" class="form-control" name="appointmentId" placeholder="Link to appointment">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-success d-block w-100">
                                <i class="fas fa-video me-2"></i>Start Video Call
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Active Call Interface -->
            <c:if test="${not empty activeCall}">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-video me-2"></i>Active Call - Patient ID: ${activeCall.patientId}
                            <span class="badge bg-light text-dark ms-2" id="callTimer">00:00</span>
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="row g-0">
                            <div class="col-md-8">
                                <!-- Real Video Call Interface -->
                                <div class="video-container position-relative" style="height: 400px; background: #000;">
                                    <!-- Remote Video (Patient) -->
                                    <video id="remoteVideo" class="w-100 h-100" style="object-fit: cover;" autoplay playsinline></video>
                                    
                                    <!-- Local Video (Doctor - small overlay) -->
                                    <video id="localVideo" 
                                           style="position: absolute; top: 10px; right: 10px; width: 120px; height: 80px; 
                                                  border-radius: 8px; border: 2px solid white; object-fit: cover;" 
                                           autoplay muted playsinline></video>
                                    
                                    <!-- Connection Status -->
                                    <div id="connectionStatus" class="position-absolute top-10 start-10 p-2">
                                        <span class="badge bg-success">
                                            <i class="fas fa-circle me-1"></i>Connected
                                        </span>
                                    </div>
                                    
                                    <!-- Call Controls Overlay -->
                                    <div class="position-absolute bottom-0 start-0 end-0 p-3 text-center" 
                                         style="background: linear-gradient(transparent, rgba(0,0,0,0.7));">
                                        <button id="muteBtn" class="btn btn-secondary btn-sm me-2" onclick="toggleMute()">
                                            <i class="fas fa-microphone"></i>
                                        </button>
                                        <button id="videoBtn" class="btn btn-secondary btn-sm me-2" onclick="toggleVideo()">
                                            <i class="fas fa-video"></i>
                                        </button>
                                        <button id="screenShareBtn" class="btn btn-info btn-sm me-2" onclick="toggleScreenShare()">
                                            <i class="fas fa-desktop"></i>
                                        </button>
                                        <button class="btn btn-danger btn-sm" onclick="endCall()">
                                            <i class="fas fa-phone-slash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 bg-light p-3">
                                <h6><i class="fas fa-info-circle me-2"></i>Call Information</h6>
                                <p><strong>Call ID:</strong> ${activeCall.callLink}</p>
                                <p><strong>Started:</strong> <fmt:formatDate value="${activeCall.startTime}" pattern="HH:mm"/></p>
                                <p><strong>Patient ID:</strong> ${activeCall.patientId}</p>
                                
                                <hr>
                                
                                <h6><i class="fas fa-notes-medical me-2"></i>Call Notes</h6>
                                <form method="post" action="video-call">
                                    <input type="hidden" name="action" value="addNotes">
                                    <input type="hidden" name="callId" value="${activeCall.id}">
                                    <textarea class="form-control mb-2" name="notes" rows="3" 
                                              placeholder="Add consultation notes..."></textarea>
                                    <button type="submit" class="btn btn-sm btn-outline-primary w-100">
                                        <i class="fas fa-save me-1"></i>Save Notes
                                    </button>
                                </form>
                            </div>
                        </div>
                        <div class="text-center p-3" style="background: rgba(0,0,0,0.05);">
                            <div class="call-controls d-inline-flex">
                                <button type="button" class="btn btn-outline-light me-2" id="muteBtn">
                                    <i class="fas fa-microphone"></i>
                                </button>
                                <button type="button" class="btn btn-outline-light me-2" id="videoBtn">
                                    <i class="fas fa-video"></i>
                                </button>
                                <button type="button" class="btn btn-outline-light me-2" id="shareBtn">
                                    <i class="fas fa-share-square"></i>
                                </button>
                                <form method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="end">
                                    <input type="hidden" name="id" value="${activeCall.id}">
                                    <input type="hidden" name="duration" id="callDuration" value="0">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-phone-slash me-1"></i>End Call
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Call History -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-history me-2"></i>Call History</h5>
                    <div>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshHistory()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success" onclick="exportHistory()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty calls}">
                            <div class="row">
                                <c:forEach var="call" items="${calls}">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card call-card ${call.status} h-100">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">Patient ID: ${call.patientId}</h6>
                                                <c:choose>
                                                    <c:when test="${call.status == 'ongoing'}">
                                                        <span class="badge bg-success">Live</span>
                                                    </c:when>
                                                    <c:when test="${call.status == 'completed'}">
                                                        <span class="badge bg-secondary">Completed</span>
                                                    </c:when>
                                                    <c:when test="${call.status == 'cancelled'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">Scheduled</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="card-body">
                                                <p class="card-text">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Started: <fmt:formatDate value="${call.startTime}" pattern="MM/dd HH:mm"/>
                                                </p>
                                                <c:if test="${call.status == 'completed' and not empty call.endTime}">
                                                    <p class="card-text">
                                                        <i class="fas fa-stop-circle me-1"></i>
                                                        Ended: <fmt:formatDate value="${call.endTime}" pattern="MM/dd HH:mm"/>
                                                    </p>
                                                    <p class="card-text">
                                                        <i class="fas fa-hourglass-half me-1"></i>
                                                        Duration: ${call.duration} minutes
                                                    </p>
                                                </c:if>
                                                <c:if test="${not empty call.appointmentId}">
                                                    <p class="card-text">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        Appointment: #${call.appointmentId}
                                                    </p>
                                                </c:if>
                                            </div>
                                            <div class="card-footer">
                                                <div class="btn-group w-100" role="group">
                                                    <c:if test="${call.status == 'ongoing'}">
                                                        <a href="${call.callLink}" target="_blank" class="btn btn-sm btn-success">
                                                            <i class="fas fa-video me-1"></i>Join
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${call.status == 'completed'}">
                                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                onclick="viewCallReport(${call.id})">
                                                            <i class="fas fa-file-alt me-1"></i>Report
                                                        </button>
                                                    </c:if>
                                                    <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                            onclick="copyCallLink('${call.callLink}')">
                                                        <i class="fas fa-copy me-1"></i>Copy Link
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-video fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Video Calls</h5>
                                <p class="text-muted">Start your first video call using the form above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Call Report Modal -->
<div class="modal fade" id="callReportModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Call Report</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="callReportContent">
                <!-- Call report content will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printReport()">
                    <i class="fas fa-print me-2"></i>Print Report
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
let callStartTime = null;
let timerInterval = null;

// Initialize call timer if there's an active call
<c:if test="${not empty activeCall}">
    callStartTime = new Date('${activeCall.startTime}').getTime();
    startCallTimer();
</c:if>

function startCallTimer() {
    timerInterval = setInterval(updateCallTimer, 1000);
}

function updateCallTimer() {
    if (!callStartTime) return;
    
    const now = new Date().getTime();
    const elapsed = Math.floor((now - callStartTime) / 1000);
    const minutes = Math.floor(elapsed / 60);
    const seconds = elapsed % 60;
    
    const timerDisplay = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
    const timerElement = document.getElementById('callTimer');
    if (timerElement) {
        timerElement.textContent = timerDisplay;
    }
    
    // Update hidden duration field
    const durationField = document.getElementById('callDuration');
    if (durationField) {
        durationField.value = minutes;
    }
}

function viewCallReport(callId) {
    // In a real implementation, this would fetch call report via AJAX
    document.getElementById('callReportContent').innerHTML = 
        '<p>Loading call report for Call ID: ' + callId + '</p>';
    new bootstrap.Modal(document.getElementById('callReportModal')).show();
}

function copyCallLink(link) {
    navigator.clipboard.writeText(link).then(function() {
        alert('Call link copied to clipboard!');
    });
}

function refreshHistory() {
    window.location.reload();
}

function exportHistory() {
    alert('Exporting call history...');
}

function printReport() {
    window.print();
}

// Call control functions
document.addEventListener('DOMContentLoaded', function() {
    const muteBtn = document.getElementById('muteBtn');
    const videoBtn = document.getElementById('videoBtn');
    const shareBtn = document.getElementById('shareBtn');
    
// WebRTC Implementation
let localStream = null;
let remoteStream = null;
let peerConnection = null;
let isAudioMuted = false;
let isVideoMuted = false;
let isScreenSharing = false;

// WebRTC configuration
const configuration = {
    iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
        { urls: 'stun:stun1.l.google.com:19302' }
    ]
};

// Initialize WebRTC when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeWebRTC();
    startCallTimer();
});

async function initializeWebRTC() {
    try {
        // Get user media (camera and microphone)
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
        
        // Add local stream to peer connection
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
        };
        
        // Handle ICE candidates
        peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log('ICE Candidate:', event.candidate);
            }
        };
        
        // Handle connection state changes
        peerConnection.onconnectionstatechange = () => {
            const state = peerConnection.connectionState;
            updateConnectionStatus(state);
        };
        
        // Simulate connection for demo
        setTimeout(() => {
            simulateConnection();
        }, 2000);
        
    } catch (error) {
        console.error('Error initializing WebRTC:', error);
        updateConnectionStatus('failed');
    }
}

async function simulateConnection() {
    try {
        const offer = await peerConnection.createOffer();
        await peerConnection.setLocalDescription(offer);
        updateConnectionStatus('connected');
    } catch (error) {
        console.error('Error in connection:', error);
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

async function toggleScreenShare() {
    try {
        const screenShareBtn = document.getElementById('screenShareBtn');
        const icon = screenShareBtn.querySelector('i');
        
        if (!isScreenSharing) {
            const screenStream = await navigator.mediaDevices.getDisplayMedia({
                video: true,
                audio: true
            });
            
            const videoTrack = screenStream.getVideoTracks()[0];
            const sender = peerConnection.getSenders().find(s => 
                s.track && s.track.kind === 'video'
            );
            
            if (sender) {
                await sender.replaceTrack(videoTrack);
            }
            
            const localVideo = document.getElementById('localVideo');
            localVideo.srcObject = screenStream;
            
            icon.className = 'fas fa-stop';
            screenShareBtn.classList.add('btn-warning');
            screenShareBtn.classList.remove('btn-info');
            isScreenSharing = true;
            
            videoTrack.onended = () => {
                stopScreenShare();
            };
            
        } else {
            stopScreenShare();
        }
    } catch (error) {
        console.error('Error toggling screen share:', error);
    }
}

async function stopScreenShare() {
    try {
        const cameraStream = await navigator.mediaDevices.getUserMedia({
            video: true,
            audio: true
        });
        
        const videoTrack = cameraStream.getVideoTracks()[0];
        const sender = peerConnection.getSenders().find(s => 
            s.track && s.track.kind === 'video'
        );
        
        if (sender) {
            await sender.replaceTrack(videoTrack);
        }
        
        const localVideo = document.getElementById('localVideo');
        localVideo.srcObject = cameraStream;
        
        const screenShareBtn = document.getElementById('screenShareBtn');
        const icon = screenShareBtn.querySelector('i');
        icon.className = 'fas fa-desktop';
        screenShareBtn.classList.remove('btn-warning');
        screenShareBtn.classList.add('btn-info');
        isScreenSharing = false;
        
    } catch (error) {
        console.error('Error stopping screen share:', error);
    }
}

function endCall() {
    if (localStream) {
        localStream.getTracks().forEach(track => track.stop());
    }
    if (peerConnection) {
        peerConnection.close();
    }
    window.location.href = '../dashboard.jsp';
}

function updateConnectionStatus(state) {
    const statusElement = document.getElementById('connectionStatus');
    if (statusElement) {
        switch (state) {
            case 'connected':
                statusElement.innerHTML = '<i class="fas fa-circle me-1"></i>Connected';
                statusElement.className = 'badge bg-success position-absolute top-10 start-10 p-2';
                break;
            case 'connecting':
                statusElement.innerHTML = '<i class="fas fa-circle me-1"></i>Connecting...';
                statusElement.className = 'badge bg-warning position-absolute top-10 start-10 p-2';
                break;
            case 'failed':
                statusElement.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i>Connection Failed';
                statusElement.className = 'badge bg-danger position-absolute top-10 start-10 p-2';
                break;
        }
    }
}

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
</script>
</body>
</html>





