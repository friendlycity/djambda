import React, { useState, useContext } from "react";
import { Form, Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import { useUserActions } from "../../hooks/user.actions";
import { Context } from "../Layout";

const UpdateProfileForm = (props) => {
    const { profile } = props;
    const navigate = useNavigate();
    const [validated, setValidated] = useState(false);
    const [form, setForm] = useState(profile);
    const [error, setError] = useState(null);
    const userActions = useUserActions();
    const { setToaster } = useContext(Context);

    const handleSubmit = (event) => {
        event.preventDefault();
        const updateProfileForm = event.currentTarget;
        if (updateProfileForm.checkValidity() === false) {
            event.stopPropagation();
        }
        setValidated(true);
        const data = {
            first_name: form.first_name,
            last_name: form.last_name,
            bio: form.bio,
        };
        const formData = new FormData();

        // Checking for null values in the form and removing it.
        Object.keys(data).forEach((key) => {
            if (data[key]) {
                formData.append(key, data[key]);
            }
        });

        userActions
        .edit(formData, profile.id)
        .then(() => {
            setToaster({
                type: "success",
                message: "Profile updated successfully 🚀",
                show: true,
                title: "Profile updated",
            });
            navigate(-1);
        })
        .catch((err) => {
            if (err.message) {
                setError(err.request.response);
            }
        });
    }

    return (
        <Form
            id="registration-form"
            className="border p-4 rounded"
            noValidate
            validated={validated}
            onSubmit={handleSubmit}
        >      
            <Form.Group className="mb-3">
                <Form.Label>First Name</Form.Label>
                <Form.Control
                    value={form.first_name}
                    onChange={(e) => setForm({ ...form, first_name: e.target.value })}
                    required
                    type="text"
                    placeholder="Enter first name"
                />
                <Form.Control.Feedback type="invalid">
                    This file is required.
                </Form.Control.Feedback>
            </Form.Group>
            <Form.Group className="mb-3">
                <Form.Label>Last name</Form.Label>
                <Form.Control
                    value={form.last_name}
                    onChange={(e) => setForm({ ...form, last_name: e.target.value })}
                    required
                    type="text"
                    placeholder="Enter last name"
                />
                <Form.Control.Feedback type="invalid">
                    This file is required.
                </Form.Control.Feedback>
            </Form.Group>
            <Form.Group className="mb-3">
                <Form.Label>Bio</Form.Label>
                <Form.Control
                    value={form.bio}
                    onChange={(e) => setForm({ ...form, bio: e.target.value })}
                    as="textarea"
                    rows={3}
                    placeholder="A simple bio ... (Optional)"
                />
            </Form.Group>
            <div className="text-content text-danger">{error && <p>{error}</p>}</div>
            <Button variant="primary" type="submit">
                Save changes
            </Button>
        </Form>
    );
}
export default UpdateProfileForm;
