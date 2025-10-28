using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace busticketbook
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateSeats();
            }
        }

        private void GenerateSeats()
        {
            int totalSeats = 20; // Example: 20 seats (5 rows × 4 seats)

            for (int i = 1; i <= totalSeats; i++)
            {
                Button btn = new Button();
                btn.Text = i.ToString();
                btn.CssClass = "btn btn-outline-primary seat-btn m-1";
                btn.ID = "Seat" + i;

                // Add click event
                btn.Click += Seat_Click;

                // Add to seat layout placeholder
                seatLayout.Controls.Add(btn);
            }
        }

        protected void Seat_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;

            // Toggle selected class
            if (btn.CssClass.Contains("seat-selected"))
            {
                btn.CssClass = "btn btn-outline-primary seat-btn m-1";
            }
            else
            {
                btn.CssClass = "btn btn-outline-primary seat-btn seat-selected m-1";
            }

            // Update selected seats
            ShowSelectedSeats();
        }

        private void ShowSelectedSeats()
        {
            List<string> selectedSeats = new List<string>();

            string selected = string.Join(", ", selectedSeats);

            // Save in hidden field
            hfSelectedSeats.Value = selected;

            lblSelectedSeats.Text = string.IsNullOrEmpty(selected)
                ? "No seats selected."
                : "Selected Seats: " + selected;
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            string selectedSeats = hfSelectedSeats.Value;

            if (string.IsNullOrEmpty(selectedSeats))
            {
                lblSelectedSeats.Text = "⚠️ No seats selected to confirm.";
            }
            else
            {
                lblSelectedSeats.Text = "✅ Booking Confirmed! Seats: " + selectedSeats;
            }
        }
    }
}
