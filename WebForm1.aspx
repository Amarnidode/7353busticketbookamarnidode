<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="busticketbook.WebForm1" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>BusGo — Book Buses Online</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            background: #f7f9fb;
            color: #222;
        }

        .seat {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            width: 40px;
            margin: 5px;
            background: #ccc;
            border-radius: 6px;
            font-size: 13px;
            transition: all 0.3s;
        }

            .seat.available:hover {
                background: #4CAF50;
                color: #fff;
            }

            .seat.selected {
                background: #ff9800 !important;
                color: white;
            }

            .seat.booked {
                background: #f44336 !important;
                color: white;
            }

        .aisle {
            width: 50px;
        }

        .seat-row {
            display: flex;
            justify-content: center;
            align-items: center;
        }


        .search-card {
            background: #fff;
            border-radius: 10px;
        }

        .hero-section {
            position: relative;
            background-image: url('https://images.unsplash.com/photo-1516455207990-7a41ce80f7ee?q=80&w=1600&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            padding: 90px 0;
            border-bottom: 1px solid rgba(0,0,0,0.04);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.28);
        }

        .aisle {
            width: 60px; /* wider gap for bus aisle */
        }


        .hero-content {
            position: relative;
            z-index: 2;
        }

        .seat.selected.male {
            background-color: #0d6efd !important; 
            color: white !important;
        }

        .seat.selected.female {
            background-color: #d63384 !important; 
            color: white !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- NAVBAR -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
            <div class="container">
                <a class="navbar-brand fw-bold" href="#">BusGo</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-between" id="navbarMenu">
                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" href="#">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Book Ticket</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">My Bookings</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Offers</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
                    </ul>
                    <div class="d-flex gap-2">
                        <a class="btn btn-outline-primary fw-bold" href="#">Login</a>
                        <a class="btn btn-primary fw-bold" href="#">Sign Up</a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- INFO / HEADING -->
        <section class="bg-light py-5">
            <div class="container text-center">
                <h1 class="display-5 fw-bold mb-3">Book Your Bus Tickets Easily</h1>
                <p class="lead mb-0">Search and reserve your bus tickets online quickly and securely. Choose your city, date, and seats, and travel stress-free!</p>
            </div>
        </section>

        <!-- HERO & Search -->
        <header class="hero-section">
            <div class="hero-overlay"></div>
            <div class="container hero-content">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="search-card p-4 shadow-sm">
                            <h3 class="mb-3">Find Your Bus</h3>
                            <div class="row g-2">
                                <div class="col-md-5">
                                    <label class="form-label small">From</label>
                                    <input list="citiesFrom" id="fromInput" class="form-control" placeholder="City or station" />
                                    <datalist id="citiesFrom">
                                        <option value="Bengaluru"></option>
                                        <option value="Hyderabad"></option>
                                        <option value="Chennai"></option>
                                        <option value="Mumbai"></option>
                                        <option value="Pune"></option>
                                        <option value="Coimbatore"></option>
                                        <option value="Vijayawada"></option>
                                    </datalist>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label small">To</label>
                                    <input list="citiesTo" id="toInput" class="form-control" placeholder="City or station" />
                                    <datalist id="citiesTo">
                                        <option value="Bengaluru"></option>
                                        <option value="Hyderabad"></option>
                                        <option value="Chennai"></option>
                                        <option value="Mumbai"></option>
                                        <option value="Pune"></option>
                                        <option value="Coimbatore"></option>
                                        <option value="Vijayawada"></option>
                                    </datalist>
                                </div>

                                <div class="col-md-4 mt-2">
                                    <label class="form-label small">Journey Date</label>
                                    <input id="journeyDate" type="date" class="form-control" />
                                </div>
                                <div class="col-md-4 mt-2">
                                    <label class="form-label small">Return Date (Optional)</label>
                                    <input id="returnDate" type="date" class="form-control" />
                                </div>
                                <div class="col-md-4 mt-2 d-flex align-items-end">
                                    <button type="button" class="btn btn-primary w-100" onclick="validateAndShowBuses()">Search Buses</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- BUS RESULTS -->
        <div id="busResults" class="container mt-5" style="display: none;">
            <h5 class="fw-bold mb-3">Available Buses</h5>
            <div id="busList" class="row g-3"></div>
        </div>

        <!-- SEAT SELECTION -->

        <div id="seatSection" style="display: none;" class="container mt-5">
            <div class="card shadow p-4">
                <h2 class="mb-4 text-center text-primary" id="busNameHeader">🎟 Seat Selection</h2>
                <div id="seatLayout" class="d-flex flex-column align-items-center"></div>

                <!-- Passenger info -->
                <div id="passengerInfoSection" class="mt-4"></div>

                <!-- Hidden fields -->
                <input type="hidden" id="hfSelectedSeats" value="" />
                <input type="hidden" id="hfBookedSeats" value="" />

                <div class="text-center mt-3">
                    <span id="lblSelectedSeats" class="fw-bold text-primary">No seats selected.</span>
                </div>

                <!-- Phone and email -->
                <div id="phoneSection" class="mb-3 text-center">
                    <input type="tel" id="commonPhone" class="form-control w-50 mx-auto mb-2" placeholder="Enter Phone Number" />
                    <input type="email" id="commonEmail" class="form-control w-50 mx-auto mb-2" placeholder="Enter Email Address" />
                    <button type="button" class="btn btn-success mt-2" onclick="showUPIQR()">Submit & Pay</button>
                </div>

                <!-- Total Amount -->
                <div class="text-center mt-4">
                    <h5 id="totalAmount" class="text-danger fw-bold mb-3">Total: ₹0</h5>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <footer class="bg-dark text-light py-4 mt-5">
            <div class="container text-center">
                <p class="mb-1">© <span id="yearSpan"></span>BusGo. All rights reserved.</p>
            </div>
        </footer>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <script>

        document.getElementById('yearSpan').textContent = new Date().getFullYear();

        function validateAndShowBuses() {
            const from = document.getElementById('fromInput').value.trim();
            const to = document.getElementById('toInput').value.trim();
            const journeyDate = document.getElementById('journeyDate').value;
            if (!from || !to) { alert('Please enter both origin and destination.'); return; }
            if (from.toLowerCase() === to.toLowerCase()) { alert('Origin and destination cannot be the same.'); return; }
            if (!journeyDate) { alert('Please choose a journey date.'); return; }
            showBusResults();
            document.getElementById('busResults').scrollIntoView({ behavior: 'smooth' });
        }

        function showBusResults() {
            const buses = [
                { name: "Volvo AC", type: "AC Seater", price: 649, departure: "08:00 AM", arrival: "02:00 PM" },
                { name: "Mercedes Non-AC", type: "Non-AC Sleeper", price: 499, departure: "09:30 AM", arrival: "03:30 PM" },
                { name: "VRL", type: "AC Sleeper", price: 799, departure: "06:00 PM", arrival: "12:00 AM" }
            ];
            const busList = document.getElementById('busList'); busList.innerHTML = "";
            buses.forEach(bus => {
                const col = document.createElement('div'); col.className = "col-md-4";
                col.innerHTML = `
            <div class="card shadow-sm p-3 h-100">
                <h6 class="fw-bold mb-1">${bus.name}</h6>
                <p class="small mb-1">${bus.type}</p>
                <p class="small mb-1">Fare: ₹${bus.price}</p>
                <p class="small mb-1">Departure: ${bus.departure}</p>
                <p class="small mb-2">Arrival: ${bus.arrival}</p>
                <button class="btn btn-primary w-100" type="button" onclick="selectBus('${bus.name}')">Select Seats</button>
            </div>`;
                busList.appendChild(col);
            });
            document.getElementById('busResults').style.display = "block";
        }

        function selectBus(busName) {
            document.getElementById('seatSection').style.display = "block";
            document.getElementById('busNameHeader').innerText = "🎟 Seat Selection - " + busName;
            renderBusSeats();
            document.getElementById('seatSection').scrollIntoView({ behavior: 'smooth' });
        }

        function renderBusSeats() {
            const seatLayout = document.getElementById("seatLayout");
            seatLayout.innerHTML = "";
            const bookedSeats = document.getElementById("hfBookedSeats").value.split(",").map(s => s.trim());

            // ===== LOWER DECK =====
            const lowerDeckHeader = document.createElement("h5");
            lowerDeckHeader.innerText = "🚌 Driver";
            lowerDeckHeader.className = "mt-3 text-success fw-bold";
            seatLayout.appendChild(lowerDeckHeader);

            // Driver section
            const driverRow = document.createElement("div");
            driverRow.className = "seat-row";
            driverRow.innerHTML = `<div class="seat driver">🪄</div>`;
            seatLayout.appendChild(driverRow);

            let lowerSeatNo = 1;
            let upperSeatNo = 1;

            for (let r = 0; r < 5; r++) {
                const row = document.createElement("div");
                row.className = "seat-row";

                // LEFT SIDE - Lower seats
                for (let c = 0; c < 2; c++) {
                    const seatId = "L" + lowerSeatNo++;
                    const seat = document.createElement("div");
                    seat.innerText = seatId;
                    seat.className = bookedSeats.includes(seatId) ? "seat booked" : "seat available";
                    seat.onclick = () => toggleSeat(seat);
                    row.appendChild(seat);
                }

                // Aisle
                const aisle = document.createElement("div");
                aisle.className = "aisle";
                row.appendChild(aisle);

                // RIGHT SIDE - Upper seats (on same row)
                for (let c = 0; c < 2; c++) {
                    const seatId = "U" + upperSeatNo++;
                    const seat = document.createElement("div");
                    seat.innerText = seatId;
                    seat.className = bookedSeats.includes(seatId) ? "seat booked" : "seat available";
                    seat.onclick = () => toggleSeat(seat);
                    row.appendChild(seat);
                }

                seatLayout.appendChild(row);
            }

            // Lower sleeper section (if needed)
            const lowerSleeperRow = document.createElement("div");
            lowerSleeperRow.className = "seat-row mt-3";
            for (let i = 0; i < 3; i++) {
                const seatId = "LS" + (i + 1);
                const sleeper = document.createElement("div");
                sleeper.innerHTML = `<span>${seatId}</span>`;
                sleeper.style.width = "80px";
                sleeper.className = bookedSeats.includes(seatId) ? "seat booked" : "seat available";
                sleeper.onclick = () => toggleSeat(sleeper);
                lowerSleeperRow.appendChild(sleeper);
            }
            seatLayout.appendChild(lowerSleeperRow);

            // Update totals and passenger info
            updateSelectedSeats();
        }


        function showUPIQR() {
            const phone = document.getElementById("commonPhone").value.trim();
            const email = document.getElementById("commonEmail").value.trim();
            const selectedSeats = document.getElementById("hfSelectedSeats").value.split(",").filter(s => s.trim() !== "");

            if (!phone) {
                Swal.fire("Phone Required", "Please enter a phone number.", "warning");
                return;
            }
            if (!email) {
                Swal.fire("Email Required", "Please enter your email.", "warning");
                return;
            }
            if (!selectedSeats.length) {
                Swal.fire("No Seats Selected", "Please select seats first.", "warning");
                return;
            }

            // Collect passenger details
            const passengers = [];
            document.querySelectorAll(".passenger-name").forEach((input, i) => {
                const seat = selectedSeats[i];
                const name = input.value.trim();
                const gender = document.querySelector(`.passenger-gender[data-seat="${seat}"]`).value;
                const age = document.querySelector(`.passenger-age[data-seat="${seat}"]`).value;
                passengers.push({ seat, name, gender, age });
            });

            // Check for empty fields
            const incomplete = passengers.some(p => !p.name || !p.age);
            if (incomplete) {
                Swal.fire("Incomplete Details", "Please fill in all passenger details.", "warning");
                return;
            }

            const seatPrice = 649;
            const totalAmount = selectedSeats.length * seatPrice;

            // Show confirmation summary first
            let htmlContent = `
        <p><b>Phone:</b> ${phone}</p>
        <p><b>Email:</b> ${email}</p>
        <hr>
        <h6>Passenger Details:</h6>
        <ul style="text-align:left;">${passengers.map(p =>
                `<li><b>${p.seat}</b> — ${p.name} (${p.gender}, ${p.age} yrs)</li>`
            ).join("")}</ul>
        <hr>
        <p><b>Total Seats:</b> ${selectedSeats.length}</p>
        <p><b>Total Fare:</b> ₹${totalAmount}</p>
    `;

            Swal.fire({
                title: "Confirm Booking Details",
                html: htmlContent,
                icon: "info",
                showCancelButton: true,
                confirmButtonText: "Confirm & Pay",
                cancelButtonText: "Edit Details"
            }).then((result) => {
                if (result.isConfirmed) {
                    // Proceed to payment step
                    Swal.fire({
                        title: `Pay ₹${totalAmount} for Seats`,
                        html: `Scan the QR code below or enter UPI ID`,
                        imageUrl: `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=upi://pay?pa=dummy@upi&pn=BusGo&am=${totalAmount}`,
                        imageWidth: 150,
                        imageHeight: 150,
                        showCancelButton: true,
                        confirmButtonText: "Paid",
                        cancelButtonText: "Cancel",
                        didOpen: () => {
                            const content = Swal.getHtmlContainer();
                            const input = document.createElement("input");
                            input.type = "text";
                            input.placeholder = "Enter UPI ID (optional)";
                            input.className = "swal2-input mt-2";
                            content.appendChild(input);
                        }
                    }).then((payResult) => {
                        if (payResult.isConfirmed) {
                            finalizeBooking(phone, email);
                        }
                    });
                }
            });
        }


        let selectedSeats = [];

        function toggleSeat(seat) {
            if (seat.classList.contains("booked")) return;

            if (seat.classList.contains("selected")) {
                seat.classList.remove("selected", "male", "female");
                seat.style.backgroundColor = "";
                seat.style.color = "";
            } else {
                seat.classList.add("selected");
                seat.style.backgroundColor = "#ff9800"; // Orange for selected
                seat.style.color = "white";
            }

            updateSelectedSeats();
        }



        function updateSelectedSeats() {
            let seatNumbers = selectedSeats.map(s => s.id).join(", ");
            document.getElementById("selectedSeatsLabel").innerText = seatNumbers ? `Selected: ${seatNumbers}` : "";
        }

        function confirmBooking() {
            const selectedSeats = document.getElementById("hfSelectedSeats").value.split(",").filter(s => s.trim() !== "");
            if (!selectedSeats.length) {
                Swal.fire("No Seats Selected", "Please select seats before proceeding.", "warning");
                return false;
            }

            // Calculate total
            const seatPrice = 649; // or dynamic if you want
            const totalAmount = selectedSeats.length * seatPrice;

            // Show dummy UPI QR code
            const paymentSection = document.getElementById("paymentSection");
            paymentSection.style.display = "block";

            const upiQR = document.getElementById("upiQR");
            if (!upiQR) {
                // create img if doesn't exist
                const img = document.createElement("img");
                img.id = "upiQR";
                img.width = 150;
                img.className = "mb-3";
                paymentSection.insertBefore(img, paymentSection.firstChild);
            }

            document.getElementById("upiQR").src = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=upi://pay?pa=dummy@upi&pn=BusGo&am=${totalAmount}`;

            // Update total amount
            document.getElementById("totalAmount").innerText = "Total: ₹" + totalAmount;

            Swal.fire({
                title: "Proceed to Payment",
                html: `Scan the QR code below to pay ₹${totalAmount}`,
                imageUrl: document.getElementById("upiQR").src,
                imageWidth: 150,
                imageHeight: 150,
                showCancelButton: true,
                confirmButtonText: "Paid",
                cancelButtonText: "Cancel"
            }).then((result) => {
                if (result.isConfirmed) {
                    finalizeBooking();
                }
            });
        }




        function updateSelectedSeats() {
            const selectedSeats = Array.from(document.getElementsByClassName("selected")).map(s => s.innerText).join(",");
            document.getElementById("hfSelectedSeats").value = selectedSeats;
            document.getElementById("lblSelectedSeats").innerText = selectedSeats ? "Selected Seats: " + selectedSeats : "No seats selected.";
        }

        function confirmBooking() {
            const selectedSeats = document.getElementById("hfSelectedSeats").value.split(",").filter(s => s.trim() !== "");
            if (!selectedSeats.length) {
                Swal.fire("No Seats Selected", "Please select seats before proceeding.", "warning");
                return false;
            }

            // Show phone number input
            document.getElementById("phoneSection").style.display = "block";
        }



        function updateSelectedSeats() {
            const selectedSeats = Array.from(document.getElementsByClassName("selected"))
                .map(s => s.innerText);

            document.getElementById("hfSelectedSeats").value = selectedSeats.join(",");

            // Update label
            const lbl = document.getElementById("lblSelectedSeats");
            if (lbl) lbl.innerText = selectedSeats.length
                ? "Selected Seats: " + selectedSeats.join(", ")
                : "No seats selected.";

            // Calculate total amount
            const seatPrice = 649; // change this if needed per seat
            const totalAmount = selectedSeats.length * seatPrice;
            document.getElementById("totalAmount").innerText = "Total: ₹" + totalAmount;

            // Render passenger info form
            renderPassengerForms(selectedSeats);
        }


        async function finalizeBooking(phone, email) {
            const { jsPDF } = window.jspdf;
            const selectedSeats = document.getElementById("hfSelectedSeats").value.split(",").filter(s => s.trim() !== "");
            const busName = document.getElementById("busNameHeader").innerText.replace("🎟 Seat Selection - ", "").trim();

            // Gather passenger info
            const passengers = [];
            selectedSeats.forEach(seat => {
                const name = document.querySelector(`.passenger-name[data-seat="${seat}"]`)?.value || "-";
                const gender = document.querySelector(`.passenger-gender[data-seat="${seat}"]`)?.value || "-";
                const age = document.querySelector(`.passenger-age[data-seat="${seat}"]`)?.value || "-";
                passengers.push({ seat, name, gender, age });
            });

            const seatPrice = 649;
            const totalAmount = selectedSeats.length * seatPrice;

            // ===== PDF GENERATION =====
            const doc = new jsPDF();
            doc.setFont("helvetica", "bold");
            doc.setFontSize(18);
            doc.text("BusGo - Booking Confirmation", 20, 20);

            doc.setFontSize(12);
            doc.setFont("helvetica", "normal");
            doc.text(`Bus: ${busName}`, 20, 35);
            doc.text(`Phone: ${phone}`, 20, 43);
            doc.text(`Email: ${email}`, 20, 51);
            doc.text(`Date: ${new Date().toLocaleDateString()}`, 20, 59);
            doc.text(`--------------------------------------------`, 20, 65);

            let y = 75;
            doc.setFont("helvetica", "bold");
            doc.text("Seat", 20, y);
            doc.text("Passenger", 50, y);
            doc.text("Gender", 110, y);
            doc.text("Age", 150, y);

            doc.setFont("helvetica", "normal");
            y += 8;

            passengers.forEach(p => {
                doc.text(p.seat, 20, y);
                doc.text(p.name, 50, y);
                doc.text(p.gender, 110, y);
                doc.text(String(p.age), 150, y);
                y += 8;
            });

            y += 5;
            doc.text(`--------------------------------------------`, 20, y);
            y += 10;
            doc.setFont("helvetica", "bold");
            doc.text(`Total Fare: ₹${totalAmount}`, 20, y);
            y += 10;
            doc.text("Thank you for booking with BusGo!", 20, y);

            // Download PDF
            doc.save(`BusGo_Ticket_${Date.now()}.pdf`);

            // ===== Update seat status visually =====
            // ===== Update seat status visually =====
            let bookedField = document.getElementById("hfBookedSeats");
            let currentBooked = bookedField.value ? bookedField.value.split(",") : [];
            bookedField.value = [...new Set([...currentBooked, ...selectedSeats])].join(",");

            // Color seats according to gender
            selectedSeats.forEach(seat => {
                const seatDiv = [...document.querySelectorAll('.seat')]
                    .find(s => s.innerText === seat);
                const gender = document.querySelector(`.passenger-gender[data-seat="${seat}"]`)?.value;

                if (seatDiv && gender) {
                    seatDiv.classList.add("booked");
                    if (gender === "Male") {
                        seatDiv.style.backgroundColor = "#0d6efd"; // Blue
                    } else {
                        seatDiv.style.backgroundColor = "#d63384"; // Pink
                    }
                    seatDiv.style.color = "white";
                }
            });

            document.getElementById("hfSelectedSeats").value = "";
            document.getElementById("commonPhone").value = "";
            document.getElementById("commonEmail").value = "";
            document.getElementById("phoneSection").style.display = "none";

            Swal.fire("🎉 Booking Successful",
                `Your booking is confirmed.<br>Seats: ${selectedSeats.join(", ")}<br>PDF ticket has been downloaded.`,
                "success"
            );
        }




        function renderPassengerForms(seats) {
            const container = document.getElementById("passengerInfoSection");
            // Listen for gender selection and update seat color instantly
            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("passenger-gender")) {
                    const seat = e.target.getAttribute("data-seat");
                    const gender = e.target.value;

                    const seatDiv = [...document.querySelectorAll(".seat")]
                        .find(s => s.innerText === seat);

                    if (seatDiv) {
                        seatDiv.classList.remove("male", "female");

                        if (gender === "Male") {
                            seatDiv.classList.add("male");
                            seatDiv.style.backgroundColor = "#0d6efd"; // Blue for male
                            seatDiv.style.color = "white";
                        } else if (gender === "Female") {
                            seatDiv.classList.add("female");
                            seatDiv.style.backgroundColor = "#d63384"; // Pink for female
                            seatDiv.style.color = "white";
                        } else {
                            // Reset color if no gender selected
                            seatDiv.style.backgroundColor = "#ff9800";
                            seatDiv.style.color = "white";
                        }
                    }
                }
            });

            container.innerHTML = ""; // Clear previous

            seats.forEach(seat => {
                const div = document.createElement("div");
                div.className = "mb-3 p-2 border rounded";
                div.innerHTML = `
            <h6 class="mb-2">Seat: ${seat}</h6>
            <div class="row g-2">
                <div class="col-md-4">
                    <input type="text" class="form-control passenger-name" placeholder="Passenger Name" data-seat="${seat}" />
                </div>
                <div class="col-md-3">
                    <select class="form-select passenger-gender" data-seat="${seat}">
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="number" min="0" class="form-control passenger-age" placeholder="Age" data-seat="${seat}" />
                </div>
            </div>
        `;
                container.appendChild(div);
            });
        }


    </script>
</body>
</html>














