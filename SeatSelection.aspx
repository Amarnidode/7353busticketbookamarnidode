<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeatSelection.aspx.cs" Inherits="busticketbook.SeatSelection" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Seat Selection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .seat { width: 40px; height: 40px; margin: 5px; text-align: center; line-height: 40px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .available { background: #4CAF50; color: #fff; }
        .selected { background: #ff9800; color: #fff; }
        .booked { background: #f44336; color: #fff; cursor: not-allowed; }
        .driver { background: black; color: white; cursor: not-allowed; }
        .seat-row { display: flex; justify-content: center; margin-bottom: 8px; }
        .aisle { width: 40px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-5">
            <h2 class="text-center text-primary mb-4" id="busNameHeader">🎟 Seat Selection</h2>
            <div id="seatLayout" class="d-flex flex-column align-items-center"></div>

            <asp:HiddenField ID="hfSelectedSeats" runat="server" />
            <asp:HiddenField ID="hfBookedSeats" runat="server" />
            <asp:Label ID="lblSelectedSeats" runat="server" CssClass="d-block mt-3 fw-bold text-primary">No seats selected.</asp:Label>

            <div class="text-center mt-4">
                <asp:Button ID="btnConfirm" runat="server" Text="Confirm Booking"
                    CssClass="btn btn-success px-4 py-2 fw-bold"
                    OnClientClick="return confirmBooking();" UseSubmitBehavior="false" />
            </div>
        </div>
    </form>

    <script>
        // Get bus name from query string
        const urlParams = new URLSearchParams(window.location.search);
        const busName = urlParams.get('bus') || "Bus";
        document.getElementById('busNameHeader').innerText = `🎟 Seat Selection - ${busName}`;

        function renderBusSeats() {
            const seatLayout = document.getElementById("seatLayout");
            seatLayout.innerHTML = "";
            let bookedSeats = document.getElementById("<%= hfBookedSeats.ClientID %>").value.split(",").map(s => s.trim());
            let seatNumber = 1;

            // Driver row
            let driverRow = document.createElement("div");
            driverRow.className = "seat-row";
            driverRow.innerHTML = `<div class="seat driver">Driver</div><div class="aisle"></div><div class="seat available">1</div>`;
            seatLayout.appendChild(driverRow);
            seatNumber = 2;

            // Lower deck: 3 rows x 4 seats
            for (let r = 0; r < 3; r++) {
                let rowDiv = document.createElement("div"); rowDiv.className = "seat-row";
                for (let c = 0; c < 4; c++) {
                    if (c === 2) { rowDiv.appendChild(document.createElement("div")).className = "aisle"; }
                    let btn = document.createElement("button"); btn.type = "button"; btn.innerText = seatNumber;
                    btn.className = bookedSeats.includes(seatNumber.toString()) ? "seat booked" : "seat available";
                    if (!bookedSeats.includes(seatNumber.toString())) { btn.onclick = () => { btn.classList.toggle("selected"); updateSelectedSeats(); }; }
                    rowDiv.appendChild(btn); seatNumber++;
                }
                seatLayout.appendChild(rowDiv);
            }

            // Upper deck: 3 rows x 4 seats
            for (let r = 0; r < 3; r++) {
                let rowDiv = document.createElement("div"); rowDiv.className = "seat-row";
                for (let c = 0; c < 4; c++) {
                    if (c === 2) { rowDiv.appendChild(document.createElement("div")).className = "aisle"; }
                    let btn = document.createElement("button"); btn.type = "button"; btn.innerText = seatNumber;
                    btn.className = bookedSeats.includes(seatNumber.toString()) ? "seat booked" : "seat available";
                    if (!bookedSeats.includes(seatNumber.toString())) { btn.onclick = () => { btn.classList.toggle("selected"); updateSelectedSeats(); }; }
                    rowDiv.appendChild(btn); seatNumber++;
                }
                seatLayout.appendChild(rowDiv);
            }
        }

        function updateSelectedSeats() {
            const selectedSeats = Array.from(document.getElementsByClassName("selected")).map(s => s.innerText).join(",");
            document.getElementById("<%= hfSelectedSeats.ClientID %>").value = selectedSeats;
            document.getElementById("<%= lblSelectedSeats.ClientID %>").innerText = selectedSeats ? "Selected Seats: " + selectedSeats : "No seats selected.";
        }

        function confirmBooking() {
            const selectedSeats = document.getElementById("<%= hfSelectedSeats.ClientID %>").value;
            if (!selectedSeats) { Swal.fire("No Seats Selected", "Please select seats before confirming.", "warning"); return false; }

            let bookedField = document.getElementById("<%= hfBookedSeats.ClientID %>");
            let currentBooked = bookedField.value ? bookedField.value.split(",") : [];
            bookedField.value = [...new Set([...currentBooked, ...selectedSeats.split(",")])].join(",");

            renderBusSeats(); updateSelectedSeats();
            Swal.fire("Booking Confirmed 🎉", `Bus: ${busName}<br>Seats: ${selectedSeats}`, "success");
            document.getElementById("<%= hfSelectedSeats.ClientID %>").value = "";
            return false;
        }

        // Only one onload function
        window.onload = () => {
            renderBusSeats();
        };
    </script>
</body>
</html>
